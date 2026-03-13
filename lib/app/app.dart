import 'package:flutter/material.dart';
import 'package:standby_hub/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
