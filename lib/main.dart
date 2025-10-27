import 'package:flutter/material.dart';
import 'package:flutter_notifications/future/home/home_view.dart';
import 'package:flutter_notifications/future/splash/splash_view.dart';
import 'package:flutter_notifications/product/init/app_initialize.dart';
import 'package:flutter_notifications/product/init/state_initialize.dart';

import 'package:go_router/go_router.dart';

part 'product/navigation/app_gorouter.dart';

Future<void> main() async {
  await AppInitialize().make();
  runApp(const StateInitialize(child: _MyApp()));
}

class _MyApp extends StatelessWidget {
  const _MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ColorCraftPro',
      // theme: AppLightTheme().themeData,
      // darkTheme: AppDarkTheme().themeData,
      routerConfig: _router,
    );
  }
}
