import 'package:standby_hub/l10n/app_localizations.dart';

enum WidgetFamily {
  small(3),
  medium(4),
  large(6);

  const WidgetFamily(this.maxSlots);

  final int maxSlots;

  String localizedName(AppLocalizations l10n) => switch (this) {
        WidgetFamily.small => l10n.widgetSizeSmall,
        WidgetFamily.medium => l10n.widgetSizeMedium,
        WidgetFamily.large => l10n.widgetSizeLarge,
      };
}
