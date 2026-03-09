import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/clock_config/clock_config_screen.dart';
import '../features/ambient_config/ambient_config_screen.dart';
import '../features/dashboard_config/dashboard_config_screen.dart';
import '../features/preview/preview_screen.dart';
import '../features/paywall/paywall_screen.dart';
import 'home_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/clocks',
      builder: (context, state) => const ClockConfigScreen(),
    ),
    GoRoute(
      path: '/ambient',
      builder: (context, state) => const AmbientConfigScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardConfigScreen(),
    ),
    GoRoute(
      path: '/preview',
      builder: (context, state) => const PreviewScreen(),
    ),
    GoRoute(
      path: '/pro',
      pageBuilder: (context, state) => MaterialPage(
        fullscreenDialog: true,
        child: const PaywallScreen(),
      ),
    ),
  ],
);
