import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_notifications/product/service/service_locator.dart';
import 'package:timezone/data/latest.dart' as tz;

@immutable
final class AppInitialize {
  Future<void> make() async {
    WidgetsFlutterBinding.ensureInitialized();

    await runZonedGuarded(_initialize, (error, stack) {
      locator.logger.e('AppInitialize error: $error ');
    });
  }

  Future<void> _initialize() async {
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    setupLocator();
    tz.initializeTimeZones();
     await locator.notification.initialize(
      onNotificationTapped: (response) {
        locator.logger.i('Bildirime tıklandı: ${response.payload}');
        // Burada navigation yapabilirsiniz
      },
    );
  }
}
