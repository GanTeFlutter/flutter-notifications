import 'package:flutter_notifications/product/service/services/logger_service.dart';
import 'package:flutter_notifications/product/service/services/notification_service.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  _registerSingletons();
}

void _registerSingletons() {
  locator
    ..registerSingleton<LoggerService>(LoggerService())
    ..registerSingleton<NotificationService>(NotificationService());
}

extension ServiceLocator on GetIt {
  LoggerService get logger => locator<LoggerService>();
  NotificationService get notification => locator<NotificationService>();
}
