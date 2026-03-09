import 'package:flutter/material.dart';

import '../shared/design_system.dart';
import 'router.dart';

class StandByHubApp extends StatelessWidget {
  const StandByHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'StandBy Hub',
      debugShowCheckedModeBanner: false,
      theme: StandByTheme.darkTheme,
      routerConfig: router,
    );
  }
}
