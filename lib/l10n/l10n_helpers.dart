import 'package:standby_hub/l10n/app_localizations.dart';

String localizedMoonPhase(AppLocalizations l10n, double p) {
  if (p < 0.0625) return l10n.moonNewMoon;
  if (p < 0.1875) return l10n.moonWaxingCrescent;
  if (p < 0.3125) return l10n.moonFirstQuarter;
  if (p < 0.4375) return l10n.moonWaxingGibbous;
  if (p < 0.5625) return l10n.moonFullMoon;
  if (p < 0.6875) return l10n.moonWaningGibbous;
  if (p < 0.8125) return l10n.moonLastQuarter;
  if (p < 0.9375) return l10n.moonWaningCrescent;
  return l10n.moonNewMoon;
}
