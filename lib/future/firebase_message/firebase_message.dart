import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  String _fcmToken = 'Token alınıyor...';
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _setupLocalNotifications();
    _setupFirebaseMessaging();
  }

  Future<void> _setupLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _localNotifications.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
  }

  Future<void> _showNotification(String title, String body) async {
    const android = AndroidNotificationDetails(
      'default_channel',
      'Bildirimler',
      importance: Importance.max,
      priority: Priority.high,
    );
    const ios = DarwinNotificationDetails();
    await _localNotifications.show(
      0,
      title,
      body,
      const NotificationDetails(android: android, iOS: ios),
    );
  }

  Future<void> _setupFirebaseMessaging() async {
    await _firebaseMessaging.requestPermission();

    final token = await _firebaseMessaging.getToken();
    setState(() => _fcmToken = token ?? 'Token alınamadı');

    // Uygulama açıkken bildirim göster
    FirebaseMessaging.onMessage.listen((message) {
      _showNotification(
        message.notification?.title ?? 'Bildirim yok',
        message.notification?.body ?? 'Body yok',
      );
      setState(() {
        _messages.insert(
          0,
          '${message.notification?.title}\n${message.notification?.body}',
        );
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      setState(() {
        _messages.insert(0, '[TIKLANDI] ${message.notification?.title}');
      });
    });

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      setState(() {
        _messages.insert(
          0,
          '[BAŞLANGIÇ] ${initialMessage.notification?.title}',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler'),
        actions: [
          if (_messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => setState(_messages.clear),
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'FCM Token:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _fcmToken));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Token kopyalandı!')),
                        );
                      },
                    ),
                  ],
                ),
                SelectableText(_fcmToken, style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text('Henüz mesaj yok'))
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: const Icon(Icons.notifications),
                      title: Text(_messages[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
