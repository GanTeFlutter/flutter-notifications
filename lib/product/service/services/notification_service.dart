import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notifications/product/service/service_locator.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  factory NotificationService() => _instance;

  NotificationService._internal();
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  int _notificationId = 0;
  bool _isInitialized = false;
  static final NotificationService _instance = NotificationService._internal();

  Future<void> initialize({
    void Function(NotificationResponse)? onNotificationTapped,
  }) async {
    if (_isInitialized) {
      locator.logger.w('NotificationService zaten başlatılmış');
      return;
    }

    try {
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      const initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (response) {
          locator.logger.i('Bildirime tıklandı: ${response.payload}');
          onNotificationTapped?.call(response);
        },
      );

      await _requestNotificationPermission();

      _isInitialized = true;
      locator.logger.i('NotificationService başarıyla başlatıldı');
    } catch (e, stackTrace) {
      locator.logger.e('NotificationService başlatma hatası: $e');
      locator.logger.e('StackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<bool> _requestNotificationPermission() async {
    try {
      final androidImplementation = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidImplementation != null) {
        final granted = await androidImplementation
            .requestNotificationsPermission();

        if (granted ?? false) {
          locator.logger.i('Bildirim izni verildi');
          return true;
        } else {
          locator.logger.w('Bildirim izni reddedildi');
          return false;
        }
      }
      return true;
    } on Exception catch (e) {
      locator.logger.e('İzin isteme hatası: $e');
      return false;
    }
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
    String? payload,
    String channelId = 'instant_channel',
    String channelName = 'Anında Bildirimler',
    String channelDescription = 'Anında gösterilen bildirimler',
  }) async {
    _checkInitialized();

    try {
      final androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        _notificationId++,
        title,
        body,
        notificationDetails,
        payload: payload ?? 'instant_$_notificationId',
      );

      locator.logger.i('Anında bildirim gönderildi: $title');
    } catch (e) {
      locator.logger.e('Anında bildirim hatası: $e');
      rethrow;
    }
  }

  Future<void> scheduleNotification({
    required String title,
    required String body,
    required Duration delay,
    String? payload,
    String channelId = 'scheduled_channel',
    String channelName = 'Zamanlanmış Bildirimler',
    String channelDescription = 'Zamanlı bildirimler',
  }) async {
    _checkInitialized();

    try {
      final androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      final scheduledDate = tz.TZDateTime.now(tz.local).add(delay);

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        _notificationId++,
        title,
        body,
        scheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      locator.logger.i(
        'Bildirim zamanlandı: $title (${delay.inSeconds} saniye sonra)',
      );
    } catch (e) {
      locator.logger.e('Zamanlı bildirim hatası: $e');
      rethrow;
    }
  }

  Future<void> scheduleNotificationAt({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String channelId = 'scheduled_channel',
    String channelName = 'Zamanlanmış Bildirimler',
    String channelDescription = 'Zamanlı bildirimler',
  }) async {
    _checkInitialized();

    try {
      final androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        _notificationId++,
        title,
        body,
        tzScheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );

      locator.logger.i('Bildirim zamanlandı: $title ($scheduledDate)');
    } catch (e) {
      locator.logger.e('Tarihli bildirim hatası: $e');
      rethrow;
    }
  }

  Future<void> showPeriodicNotification({
    required String title,
    required String body,
    required RepeatInterval repeatInterval,
    String? payload,
    String channelId = 'periodic_channel',
    String channelName = 'Periyodik Bildirimler',
    String channelDescription = 'Düzenli tekrarlanan bildirimler',
  }) async {
    _checkInitialized();

    try {
      final androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await _flutterLocalNotificationsPlugin.periodicallyShow(
        _notificationId++,
        title,
        body,
        repeatInterval,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );

      locator.logger.i('Periyodik bildirim başlatıldı: $title');
    } catch (e) {
      locator.logger.e('Periyodik bildirim hatası: $e');
      rethrow;
    }
  }

  Future<void> cancelNotification(int id) async {
    _checkInitialized();

    try {
      await _flutterLocalNotificationsPlugin.cancel(id);
      locator.logger.i('Bildirim iptal edildi: $id');
    } catch (e) {
      locator.logger.e('Bildirim iptal hatası: $e');
      rethrow;
    }
  }

  Future<void> cancelAllNotifications() async {
    _checkInitialized();

    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      locator.logger.i('Tüm bildirimler iptal edildi');
    } catch (e) {
      locator.logger.e('Tüm bildirimleri iptal etme hatası: $e');
      rethrow;
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    _checkInitialized();

    try {
      final pendingNotifications = await _flutterLocalNotificationsPlugin
          .pendingNotificationRequests();
      locator.logger.i(
        'Bekleyen bildirim sayısı: ${pendingNotifications.length}',
      );
      return pendingNotifications;
    } catch (e) {
      locator.logger.e('Bekleyen bildirimleri getirme hatası: $e');
      rethrow;
    }
  }

  Future<List<ActiveNotification>> getActiveNotifications() async {
    _checkInitialized();

    try {
      final activeNotifications = await _flutterLocalNotificationsPlugin
          .getActiveNotifications();
      locator.logger.i(
        'Aktif bildirim sayısı: ${activeNotifications.length}',
      );
      return activeNotifications;
    } catch (e) {
      locator.logger.e('Aktif bildirimleri getirme hatası: $e');
      rethrow;
    }
  }

  void _checkInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'NotificationService başlatılmamış! Lütfen önce initialize() metodunu çağırın.',
      );
    }
  }

  bool get isInitialized => _isInitialized;

  int get nextNotificationId => _notificationId;
}
