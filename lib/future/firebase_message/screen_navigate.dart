import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationTestScreen extends StatefulWidget {
  const NotificationTestScreen({super.key});

  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String _lastMessage = 'Henüz mesaj yok';

  // Stream subscription'ları tutmak için
  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() async {
    // Uygulama kapalıyken bildirimi yakala
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Uygulama açık veya background'tayken bildirime tıklanırsa yakala
    _onMessageSubscription = FirebaseMessaging.onMessage.listen((message) {
      // mounted kontrolü ekle
      if (mounted) {
        setState(() {
          _lastMessage = 'Foreground mesaj geldi:\n${message.data.toString()}';
        });
      }
    });

    _onMessageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp
        .listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    // mounted kontrolü ekle
    if (!mounted) return;

    if (message.data['type'] == 'chat') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            sender: (message.data['sender'] ?? 'Bilinmiyor').toString(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Stream subscription'ları iptal et
    _onMessageSubscription?.cancel();
    _onMessageOpenedAppSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Bildirim Ekranı')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Son Mesaj:\n$_lastMessage',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Firebase Console\'dan "type: chat" ve "sender: admin" değerlerini ekleyip test mesajı gönderin.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Basit Chat ekranı
class ChatScreen extends StatelessWidget {
  final String sender;
  const ChatScreen({super.key, required this.sender});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Ekranı')),
      body: Center(
        child: Text(
          'Chat mesajı $sender tarafından geldi!',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
