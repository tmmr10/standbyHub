import 'package:standby_hub/l10n/app_localizations.dart';

enum DashboardSlotType {
  clock('Uhrzeit', 'access_time', false),
  calendar('Nächster Termin', 'calendar_today', false),
  weather('Wetter', 'cloud', false),
  battery('Batterie', 'battery_full', false),
  moonPhase('Mondphase', 'dark_mode', false),
  photo('Foto', 'image', false);

  const DashboardSlotType(this.displayName, this.iconName, this.isPro);

  final String displayName;
  final String iconName;
  final bool isPro;

  String localizedName(AppLocalizations l10n) => switch (this) {
        DashboardSlotType.clock => l10n.slotClock,
        DashboardSlotType.calendar => l10n.slotCalendar,
        DashboardSlotType.weather => l10n.slotWeather,
        DashboardSlotType.battery => l10n.slotBattery,
        DashboardSlotType.moonPhase => l10n.slotMoonPhase,
        DashboardSlotType.photo => l10n.slotPhoto,
      };
}

class DashboardSlot {
  const DashboardSlot({
    required this.type,
    this.enabled = true,
    this.position = 0,
  });

  final DashboardSlotType type;
  final bool enabled;
  final int position;

  DashboardSlot copyWith({
    DashboardSlotType? type,
    bool? enabled,
    int? position,
  }) {
    return DashboardSlot(
      type: type ?? this.type,
      enabled: enabled ?? this.enabled,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'enabled': enabled,
        'position': position,
      };

  factory DashboardSlot.fromJson(Map<String, dynamic> json) {
    final typeName = json['type'] as String;
    final type = DashboardSlotType.values
            .where((e) => e.name == typeName)
            .firstOrNull ??
        DashboardSlotType.calendar;
    return DashboardSlot(
      type: type,
      enabled: json['enabled'] as bool? ?? true,
      position: json['position'] as int? ?? 0,
    );
  }
}

/// A saved dashboard configuration
class SavedDashboard {
  const SavedDashboard({
    required this.name,
    required this.slots,
    this.accentColorHex = '',
  });

  final String name;
  final List<DashboardSlot> slots;
  final String accentColorHex;

  Map<String, dynamic> toJson() => {
        'name': name,
        'slots': slots.map((s) => s.toJson()).toList(),
        'accentColorHex': accentColorHex,
      };

  factory SavedDashboard.fromJson(Map<String, dynamic> json) => SavedDashboard(
        name: json['name'] as String,
        slots: (json['slots'] as List<dynamic>)
            .map((e) => DashboardSlot.fromJson(e as Map<String, dynamic>))
            .toList(),
        accentColorHex: json['accentColorHex'] as String? ?? '',
      );
}
