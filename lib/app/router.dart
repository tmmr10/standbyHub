import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/battery_config/battery_config_screen.dart';
import '../features/calendar_config/calendar_config_screen.dart';
import '../features/clock_config/clock_config_screen.dart';
import '../features/dashboard_config/dashboard_config_screen.dart';
import '../features/moon_phase_config/moon_phase_config_screen.dart';
import '../features/photo_config/photo_config_screen.dart';
import '../features/preview/preview_screen.dart';
import '../features/paywall/paywall_screen.dart';
import '../features/weather_config/weather_config_screen.dart';
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
      path: '/calendar',
      builder: (context, state) => const CalendarConfigScreen(),
    ),
    GoRoute(
      path: '/weather',
      builder: (context, state) => const WeatherConfigScreen(),
    ),
    GoRoute(
      path: '/battery',
      builder: (context, state) => const BatteryConfigScreen(),
    ),
    GoRoute(
      path: '/moon-phase',
      builder: (context, state) => const MoonPhaseConfigScreen(),
    ),
    GoRoute(
      path: '/photo',
      builder: (context, state) => const PhotoConfigScreen(),
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
      pageBuilder: (context, state) => CustomTransitionPage(
        fullscreenDialog: true,
        child: const PaywallScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
  ],
);
