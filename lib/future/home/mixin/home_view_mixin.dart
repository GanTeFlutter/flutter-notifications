import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notifications/future/home/home_view.dart';
import 'package:flutter_notifications/product/service/service_locator.dart';
import 'package:flutter_notifications/product/service/services/notification_service.dart';

mixin HomeViewMixin on State<HomeView> {
  // Controllers
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final delayController = TextEditingController(text: '5');

  // Service
  late final NotificationService notificationService;

  // State
  String pendingNotificationsInfo = 'Bekleyen bildirim yok';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    notificationService = locator<NotificationService>();
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    delayController.dispose();
    super.dispose();
  }

  // SnackBar göster
  Future<void> showSnackBar(String message, {bool isError = false}) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Bekleyen bildirimleri güncelle
  Future<void> updatePendingNotifications() async {
    setState(() => isLoading = true);
    try {
      final pending = await notificationService.getPendingNotifications();
      setState(() {
        pendingNotificationsInfo = pending.isEmpty
            ? 'Bekleyen bildirim yok'
            : '${pending.length} bildirim bekliyor:\n${pending.map((n) => '• ${n.title ?? "Başlıksız"}').join('\n')}';
      });
    } on Exception catch (e) {
      await showSnackBar('Bildirimler alınamadı: $e', isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Anında bildirim gönder
  Future<void> sendInstantNotification() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      await notificationService.showInstantNotification(
        title: titleController.text.trim(),
        body: bodyController.text.trim(),
      );
      await showSnackBar('Bildirim gönderildi');
      await updatePendingNotifications();
    } on Exception catch (e) {
      await showSnackBar('Bildirim gönderilemedi: $e', isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Zamanlanmış bildirim gönder
  Future<void> scheduleNotification() async {
    if (!formKey.currentState!.validate()) return;

    final delaySeconds = int.tryParse(delayController.text);
    if (delaySeconds == null || delaySeconds <= 0) {
      await showSnackBar('Geçerli bir süre girin', isError: true);
      return;
    }

    setState(() => isLoading = true);
    try {
      await notificationService.scheduleNotification(
        title: titleController.text.trim(),
        body: bodyController.text.trim(),
        delay: Duration(seconds: delaySeconds),
      );
      await showSnackBar('Bildirim $delaySeconds saniye sonraya zamanlandı');
      await updatePendingNotifications();
    } on Exception catch (e) {
      await showSnackBar(
        'Bildirim zamanlanamadı: $e',
        isError: true,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Periyodik bildirim gönder
  Future<void> sendPeriodicNotification() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      await notificationService.showPeriodicNotification(
        title: titleController.text.trim(),
        body: bodyController.text.trim(),
        repeatInterval: RepeatInterval.everyMinute,
      );
      await showSnackBar('Periyodik bildirim başlatıldı');
      await updatePendingNotifications();
    } on Exception catch (e) {
      await showSnackBar('Periyodik bildirim başlatılamadı: $e', isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Tüm bildirimleri iptal et
  Future<void> cancelAllNotifications() async {
    setState(() => isLoading = true);
    try {
      await notificationService.cancelAllNotifications();
      await showSnackBar('Tüm bildirimler iptal edildi');
      await updatePendingNotifications();
    } on Exception catch (e) {
      await showSnackBar('Bildirimler iptal edilemedi: $e', isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }
}
