// import 'dart:async';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// // 1. Global handler - uygulama kapalıyken arka planda çalışır
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('Background message: ${message.data}');
// }

// // 2. Notification Service - Tüm bildirim logic'ini yönetir
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final StreamController<RemoteMessage> _messageStreamController =
//       StreamController<RemoteMessage>.broadcast();

//   // Bu stream'i dinleyerek notification'ları handle edebiliriz
//   Stream<RemoteMessage> get messageStream => _messageStreamController.stream;

//   Future<void> initialize() async {
//     // İzin iste
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('Bildirim izni verildi');
//     }

//     // FCM Token al
//     String? token = await _messaging.getToken();
//     print('FCM Token: $token');

//     // Token yenilendiğinde
//     _messaging.onTokenRefresh.listen((newToken) {
//       print('Token yenilendi: $newToken');
//       // Backend'e yeni token'ı gönder
//     });

//     // Uygulama tamamen kapalıyken bildirime tıklanmış mı kontrol et
//     RemoteMessage? initialMessage = await _messaging.getInitialMessage();
//     if (initialMessage != null) {
//       _messageStreamController.add(initialMessage);
//     }

//     // Uygulama açıkken bildirim gelirse
//     FirebaseMessaging.onMessage.listen((message) {
//       print('Foreground message: ${message.data}');
//       // Burada kendi notification'ınızı gösterebilirsiniz
//       _messageStreamController.add(message);
//     });

//     // Uygulama background'tayken bildirime tıklanırsa
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       print('Opened from background: ${message.data}');
//       _messageStreamController.add(message);
//     });
//   }

//   void dispose() {
//     _messageStreamController.close();
//   }
// }

// // 3. Main.dart'ta kullanım
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // Background handler'ı kaydet
//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//   // Notification service'i başlat
//   await NotificationService().initialize();
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//   StreamSubscription<RemoteMessage>? _messageSubscription;

//   @override
//   void initState() {
//     super.initState();
//     _setupNotificationListener();
//   }

//   void _setupNotificationListener() {
//     // Notification stream'i dinle
//     _messageSubscription = NotificationService().messageStream.listen((
//       message,
//     ) {
//       _handleNotificationNavigation(message);
//     });
//   }

//   void _handleNotificationNavigation(RemoteMessage message) {
//     // Navigation'ı global key ile yap
//     final context = navigatorKey.currentContext;
//     if (context == null) return;

//     final type = message.data['type'];

//     if (type == 'chat') {
//       final sender = message.data['sender'] ?? 'Bilinmiyor';
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => ChatScreen(sender: sender.toString()),
//         ),
//       );
//     } else if (type == 'profile') {
//       final userId = message.data['userId'];
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => ProfileScreen(userId: userId.toString()),
//         ),
//       );
//     }
//     // Diğer case'ler...
//   }

//   @override
//   void dispose() {
//     _messageSubscription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: navigatorKey, // ÖNEMLİ: Global navigator key
//       title: 'Firebase Notifications',
//       home: const HomeScreen(),
//       routes: {
//         '/home': (context) => const HomeScreen(),
//         '/notifications': (context) => const NotificationTestScreen(),
//       },
//     );
//   }
// }

// // 4. Ana Ekran
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Ana Sayfa')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const NotificationTestScreen(),
//                   ),
//                 );
//               },
//               child: const Text('Test Ekranına Git'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // 5. Test Ekranı - Artık navigation logic yok
// class NotificationTestScreen extends StatefulWidget {
//   const NotificationTestScreen({super.key});

//   @override
//   State<NotificationTestScreen> createState() => _NotificationTestScreenState();
// }

// class _NotificationTestScreenState extends State<NotificationTestScreen> {
//   String _lastMessage = 'Henüz mesaj yok';
//   StreamSubscription<RemoteMessage>? _messageSubscription;

//   @override
//   void initState() {
//     super.initState();
//     _listenToMessages();
//   }

//   void _listenToMessages() {
//     _messageSubscription = NotificationService().messageStream.listen((
//       message,
//     ) {
//       if (mounted) {
//         setState(() {
//           _lastMessage =
//               'Mesaj geldi:\nType: ${message.data['type']}\n'
//               'Sender: ${message.data['sender']}\n'
//               'Data: ${message.data.toString()}';
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _messageSubscription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Test Bildirim Ekranı')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               'Son Mesaj:\n$_lastMessage',
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Firebase Console\'dan test mesajı gönderin:\n\n'
//               'Custom data:\n'
//               '• type: chat\n'
//               '• sender: admin',
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // 6. Chat Ekranı
// class ChatScreen extends StatelessWidget {
//   final String sender;
//   const ChatScreen({super.key, required this.sender});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat Ekranı')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Chat mesajı $sender tarafından geldi!',
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Geri Dön'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // 7. Profil Ekranı (örnek)
// class ProfileScreen extends StatelessWidget {
//   final String userId;
//   const ProfileScreen({super.key, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Profil Ekranı')),
//       body: Center(
//         child: Text(
//           'Profil: $userId',
//           style: const TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }
