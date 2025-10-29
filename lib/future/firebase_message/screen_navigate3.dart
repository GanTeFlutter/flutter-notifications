import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ScreenNavigate3 extends StatefulWidget {
  const ScreenNavigate3({super.key});

  @override
  State<ScreenNavigate3> createState() => _ScreenNavigate3State();
}

class _ScreenNavigate3State extends State<ScreenNavigate3> {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  String? fcm;

  // kullanicidan izin isteme
  Future<void> fcmTest() async {
    // requestPermission icinden
    final settings = await messaging.requestPermission();
    setState(() {
      fcm = settings.authorizationStatus.name;
    });
  }

  /*
  fcm izin durumları:
  authorized: Kullanıcı izin verdi.
  denied: Kullanıcı izni reddetti.
  notDetermined: Kullanıcı henüz izin verip vermeyeceğine karar vermemiştir.
  provisional: Kullanıcı, geçici izin verdi.

  uygulama 2 kez izin ister ve kullanıcı 2 kez reddederse bir daha izin isteyemezsiniz androidin default davranışı bu şekildedir.
  kullanıcı ayarlardan manuel olarak izni açması gerekir.
  */
  //-----------------------------------------------------

  //android 13+ ve ios/macOS için popup gösterip izni kontrol eden method
  // 13+ altı android sürümlerinde izin otomatik verilir ancakkk kullanıcı eğer ayarlardan kapattıysa ve onu açtırmak istiyorsak bu methodu kullanabiliriz
  String _status = 'Henüz kontrol edilmedi';

  Future<void> checkAndRequestPermission() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      setState(() => _status = 'İzin zaten verilmiş');
      return;
    }

    // Android 13+ veya iOS/macOS popup göster
    final newSettings = await FirebaseMessaging.instance.requestPermission();

    if (newSettings.authorizationStatus == AuthorizationStatus.authorized) {
      setState(() => _status = 'İzin verildi');
    } else if (newSettings.authorizationStatus == AuthorizationStatus.denied) {
      setState(() => _status = 'İzin reddedildi, ayarlara yönlendiriliyor...');
      // Kullanıcıyı ayarlara yönlendir
    } else {
      setState(
        () => _status = 'İzin durumu: ${newSettings.authorizationStatus}',
      );
    }
  }

  void uygulamaAcikken() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screennavigate3 FCM Test')),
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('FCM İzin Durumu: ${fcm ?? 'Belirtilmemiş'}'),
            Text('İzin Kontrol Durumu: $_status'),
            ElevatedButton(
              onPressed: fcmTest,
              child: const Text('FCM İzin İste'),
            ),
          ],
        ),
      ),
    );
  }
}
