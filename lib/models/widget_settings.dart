import 'dart:convert';

import 'clock_style.dart';
import 'ambient_mode.dart';
import 'dashboard_slot.dart';

class WidgetSettings {
  const WidgetSettings({
    this.selectedClock = ClockStyle.minimalDigital,
    this.selectedAmbient = AmbientMode.aurora,
    this.accentColorHex = 'FF00DDFF',
    this.showSeconds = false,
    this.use24HourFormat = true,
    this.timeOfDayReactivity = false,
    this.dashboardSlots = const [],
    this.isPro = false,
  });

  final ClockStyle selectedClock;
  final AmbientMode selectedAmbient;
  final String accentColorHex;
  final bool showSeconds;
  final bool use24HourFormat;
  final bool timeOfDayReactivity;
  final List<DashboardSlot> dashboardSlots;
  final bool isPro;

  WidgetSettings copyWith({
    ClockStyle? selectedClock,
    AmbientMode? selectedAmbient,
    String? accentColorHex,
    bool? showSeconds,
    bool? use24HourFormat,
    bool? timeOfDayReactivity,
    List<DashboardSlot>? dashboardSlots,
    bool? isPro,
  }) {
    return WidgetSettings(
      selectedClock: selectedClock ?? this.selectedClock,
      selectedAmbient: selectedAmbient ?? this.selectedAmbient,
      accentColorHex: accentColorHex ?? this.accentColorHex,
      showSeconds: showSeconds ?? this.showSeconds,
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
      timeOfDayReactivity: timeOfDayReactivity ?? this.timeOfDayReactivity,
      dashboardSlots: dashboardSlots ?? this.dashboardSlots,
      isPro: isPro ?? this.isPro,
    );
  }

  Map<String, dynamic> toJson() => {
        'selectedClock': selectedClock.name,
        'selectedAmbient': selectedAmbient.name,
        'accentColorHex': accentColorHex,
        'showSeconds': showSeconds,
        'use24HourFormat': use24HourFormat,
        'timeOfDayReactivity': timeOfDayReactivity,
        'dashboardSlots': dashboardSlots.map((s) => s.toJson()).toList(),
        'isPro': isPro,
      };

  String toJsonString() => jsonEncode(toJson());

  factory WidgetSettings.fromJson(Map<String, dynamic> json) {
    return WidgetSettings(
      selectedClock: ClockStyle.values.byName(
        json['selectedClock'] as String? ?? 'minimalDigital',
      ),
      selectedAmbient: AmbientMode.values.byName(
        json['selectedAmbient'] as String? ?? 'aurora',
      ),
      accentColorHex: json['accentColorHex'] as String? ?? 'FF00DDFF',
      showSeconds: json['showSeconds'] as bool? ?? false,
      use24HourFormat: json['use24HourFormat'] as bool? ?? true,
      timeOfDayReactivity: json['timeOfDayReactivity'] as bool? ?? false,
      dashboardSlots: (json['dashboardSlots'] as List<dynamic>?)
              ?.map((e) => DashboardSlot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isPro: json['isPro'] as bool? ?? false,
    );
  }

  factory WidgetSettings.fromJsonString(String jsonString) {
    return WidgetSettings.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }

  static WidgetSettings defaultSettings() {
    return const WidgetSettings(
      dashboardSlots: [
        DashboardSlot(type: DashboardSlotType.calendar, position: 0),
        DashboardSlot(type: DashboardSlotType.weather, position: 1),
        DashboardSlot(type: DashboardSlotType.battery, position: 2),
      ],
    );
  }
}
