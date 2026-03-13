import 'package:standby_hub/l10n/app_localizations.dart';

enum AmbientMode {
  none('Kein Hintergrund', 'Reines OLED Schwarz', false),
  aurora('Aurora', 'Nordlicht-Farbverläufe', false),
  lava('Lava', 'Warme Orange/Rot-Töne', false),
  ocean('Ocean', 'Kühle Blau/Türkis-Töne', false),
  sunset('Sunset', 'Warme Abendrot-Töne', true),
  forest('Forest', 'Tiefes Waldgrün', true),
  nebula('Nebula', 'Kosmisches Violett/Pink', true),
  custom('Eigene Farbe', 'Wähle deine Hintergrundfarbe', true),
  image('Eigenes Bild', 'Foto als Hintergrund', false);

  const AmbientMode(this.displayName, this.description, this.isPro);

  final String displayName;
  final String description;
  final bool isPro;

  String localizedName(AppLocalizations l10n) => switch (this) {
        AmbientMode.none => l10n.ambientNone,
        AmbientMode.aurora => l10n.ambientAurora,
        AmbientMode.lava => l10n.ambientLava,
        AmbientMode.ocean => l10n.ambientOcean,
        AmbientMode.sunset => l10n.ambientSunset,
        AmbientMode.forest => l10n.ambientForest,
        AmbientMode.nebula => l10n.ambientNebula,
        AmbientMode.custom => l10n.ambientCustom,
        AmbientMode.image => l10n.ambientImage,
      };

  String localizedDescription(AppLocalizations l10n) => switch (this) {
        AmbientMode.none => l10n.ambientNoneDesc,
        AmbientMode.aurora => l10n.ambientAuroraDesc,
        AmbientMode.lava => l10n.ambientLavaDesc,
        AmbientMode.ocean => l10n.ambientOceanDesc,
        AmbientMode.sunset => l10n.ambientSunsetDesc,
        AmbientMode.forest => l10n.ambientForestDesc,
        AmbientMode.nebula => l10n.ambientNebulaDesc,
        AmbientMode.custom => l10n.ambientCustomDesc,
        AmbientMode.image => l10n.ambientImageDesc,
      };
}
