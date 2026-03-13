import 'package:standby_hub/l10n/app_localizations.dart';

enum ClockStyle {
  flipClock('Flip Clock', 'Retro Split-Flap Design', true),
  minimalDigital('Digital', 'Schlichte Digitaluhr mit Datum', false),
  analogClassic('Analog Classic', 'Klassische Zeiger-Uhr', false),
  binaryClock('Binary Clock', 'LED-Dot-Matrix-Look', true),
  pixelArtClock('Pixel Art Uhr', 'Retro-Pixel-Szenen & Uhrzeit', true);

  const ClockStyle(this.displayName, this.description, this.isPro);

  final String displayName;
  final String description;
  final bool isPro;

  String localizedName(AppLocalizations l10n) => switch (this) {
        ClockStyle.flipClock => l10n.clockFlipClock,
        ClockStyle.minimalDigital => l10n.clockDigital,
        ClockStyle.analogClassic => l10n.clockAnalog,
        ClockStyle.binaryClock => l10n.clockBinary,
        ClockStyle.pixelArtClock => l10n.clockPixelArt,
      };

  String localizedDescription(AppLocalizations l10n) => switch (this) {
        ClockStyle.flipClock => l10n.clockFlipClockDesc,
        ClockStyle.minimalDigital => l10n.clockDigitalDesc,
        ClockStyle.analogClassic => l10n.clockAnalogDesc,
        ClockStyle.binaryClock => l10n.clockBinaryDesc,
        ClockStyle.pixelArtClock => l10n.clockPixelArtDesc,
      };
}
