part of '../../main.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const ScreenNavigate3();
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/notificationView',
          name: 'NotificationView',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeView();
          },
        ),
        GoRoute(
          path: '/notificationScreen',
          name: 'NotificationScreen',
          builder: (BuildContext context, GoRouterState state) {
            return const NotificationScreen();
          },
        ),
      ],
    ),
  ],
);
