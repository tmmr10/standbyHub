import 'dart:convert';

import 'clock_style.dart';
import 'ambient_mode.dart';
import 'dashboard_slot.dart';

class WidgetSettings {
  const WidgetSettings({
    this.selectedClock = ClockStyle.minimalDigital,
    this.selectedAmbient = AmbientMode.none,
    this.accentColorHex = 'FFFFFFFF',
    this.backgroundColorHex = 'FF1A237E',
    this.showSeconds = false,
    this.use24HourFormat = true,
    this.timeOfDayReactivity = false,
    this.dashboardSlots = const [],
    this.isPro = false,
    this.temperatureUnit = 'celsius',
    this.calendarAccentHex = '',
    this.weatherAccentHex = '',
    this.batteryAccentHex = '',
    this.dashboardPreset = 'all',
    this.dashboardAccentHex = '',
    this.savedDashboards = const [],
    this.calendarBackgroundHex = '',
    this.calendarAmbient = AmbientMode.none,
    this.weatherBackgroundHex = '',
    this.weatherAmbient = AmbientMode.none,
    this.batteryBackgroundHex = '',
    this.batteryAmbient = AmbientMode.none,
    this.dashboardBackgroundHex = '',
    this.dashboardAmbient = AmbientMode.none,
    this.moonPhaseAccentHex = '',
    this.moonPhaseBackgroundHex = '',
    this.moonPhaseAmbient = AmbientMode.none,
    this.clockBackgroundImage = '',
    this.calendarBackgroundImage = '',
    this.weatherBackgroundImage = '',
    this.batteryBackgroundImage = '',
    this.dashboardBackgroundImage = '',
    this.moonPhaseBackgroundImage = '',
    this.photoWidgetImage = '',
  });

  final ClockStyle selectedClock;
  final AmbientMode selectedAmbient;
  final String accentColorHex;
  final String backgroundColorHex;
  final bool showSeconds;
  final bool use24HourFormat;
  final bool timeOfDayReactivity;
  final List<DashboardSlot> dashboardSlots;
  final bool isPro;
  final String temperatureUnit;
  final String calendarAccentHex;
  final String weatherAccentHex;
  final String batteryAccentHex;
  final String dashboardPreset;
  final String dashboardAccentHex; // dashboard-specific accent
  final List<SavedDashboard> savedDashboards;
  final String calendarBackgroundHex;
  final AmbientMode calendarAmbient;
  final String weatherBackgroundHex;
  final AmbientMode weatherAmbient;
  final String batteryBackgroundHex;
  final AmbientMode batteryAmbient;
  final String dashboardBackgroundHex;
  final AmbientMode dashboardAmbient;
  final String moonPhaseAccentHex;
  final String moonPhaseBackgroundHex;
  final AmbientMode moonPhaseAmbient;
  final String clockBackgroundImage;
  final String calendarBackgroundImage;
  final String weatherBackgroundImage;
  final String batteryBackgroundImage;
  final String dashboardBackgroundImage;
  final String moonPhaseBackgroundImage;
  final String photoWidgetImage;

  /// Resolved accent for a specific widget type (falls back to global)
  String accentForSlot(DashboardSlotType type) {
    final override = switch (type) {
      DashboardSlotType.clock => '',
      DashboardSlotType.calendar => calendarAccentHex,
      DashboardSlotType.weather => weatherAccentHex,
      DashboardSlotType.battery => batteryAccentHex,
      DashboardSlotType.moonPhase => moonPhaseAccentHex,
      DashboardSlotType.photo => '',
    };
    return override.isNotEmpty ? override : accentColorHex;
  }

  /// Resolved background for a specific widget type (empty = true black)
  String backgroundForSlot(DashboardSlotType type) {
    return switch (type) {
      DashboardSlotType.clock => backgroundColorHex,
      DashboardSlotType.calendar => calendarBackgroundHex,
      DashboardSlotType.weather => weatherBackgroundHex,
      DashboardSlotType.battery => batteryBackgroundHex,
      DashboardSlotType.moonPhase => moonPhaseBackgroundHex,
      DashboardSlotType.photo => '',
    };
  }

  WidgetSettings copyWith({
    ClockStyle? selectedClock,
    AmbientMode? selectedAmbient,
    String? accentColorHex,
    String? backgroundColorHex,
    bool? showSeconds,
    bool? use24HourFormat,
    bool? timeOfDayReactivity,
    List<DashboardSlot>? dashboardSlots,
    bool? isPro,
    String? temperatureUnit,
    String? calendarAccentHex,
    String? weatherAccentHex,
    String? batteryAccentHex,
    String? dashboardPreset,
    String? dashboardAccentHex,
    List<SavedDashboard>? savedDashboards,
    String? calendarBackgroundHex,
    AmbientMode? calendarAmbient,
    String? weatherBackgroundHex,
    AmbientMode? weatherAmbient,
    String? batteryBackgroundHex,
    AmbientMode? batteryAmbient,
    String? dashboardBackgroundHex,
    AmbientMode? dashboardAmbient,
    String? moonPhaseAccentHex,
    String? moonPhaseBackgroundHex,
    AmbientMode? moonPhaseAmbient,
    String? clockBackgroundImage,
    String? calendarBackgroundImage,
    String? weatherBackgroundImage,
    String? batteryBackgroundImage,
    String? dashboardBackgroundImage,
    String? moonPhaseBackgroundImage,
    String? photoWidgetImage,
  }) {
    return WidgetSettings(
      selectedClock: selectedClock ?? this.selectedClock,
      selectedAmbient: selectedAmbient ?? this.selectedAmbient,
      accentColorHex: accentColorHex ?? this.accentColorHex,
      backgroundColorHex: backgroundColorHex ?? this.backgroundColorHex,
      showSeconds: showSeconds ?? this.showSeconds,
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
      timeOfDayReactivity: timeOfDayReactivity ?? this.timeOfDayReactivity,
      dashboardSlots: dashboardSlots ?? this.dashboardSlots,
      isPro: isPro ?? this.isPro,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      calendarAccentHex: calendarAccentHex ?? this.calendarAccentHex,
      weatherAccentHex: weatherAccentHex ?? this.weatherAccentHex,
      batteryAccentHex: batteryAccentHex ?? this.batteryAccentHex,
      dashboardPreset: dashboardPreset ?? this.dashboardPreset,
      dashboardAccentHex: dashboardAccentHex ?? this.dashboardAccentHex,
      savedDashboards: savedDashboards ?? this.savedDashboards,
      calendarBackgroundHex: calendarBackgroundHex ?? this.calendarBackgroundHex,
      calendarAmbient: calendarAmbient ?? this.calendarAmbient,
      weatherBackgroundHex: weatherBackgroundHex ?? this.weatherBackgroundHex,
      weatherAmbient: weatherAmbient ?? this.weatherAmbient,
      batteryBackgroundHex: batteryBackgroundHex ?? this.batteryBackgroundHex,
      batteryAmbient: batteryAmbient ?? this.batteryAmbient,
      dashboardBackgroundHex: dashboardBackgroundHex ?? this.dashboardBackgroundHex,
      dashboardAmbient: dashboardAmbient ?? this.dashboardAmbient,
      moonPhaseAccentHex: moonPhaseAccentHex ?? this.moonPhaseAccentHex,
      moonPhaseBackgroundHex: moonPhaseBackgroundHex ?? this.moonPhaseBackgroundHex,
      moonPhaseAmbient: moonPhaseAmbient ?? this.moonPhaseAmbient,
      clockBackgroundImage: clockBackgroundImage ?? this.clockBackgroundImage,
      calendarBackgroundImage: calendarBackgroundImage ?? this.calendarBackgroundImage,
      weatherBackgroundImage: weatherBackgroundImage ?? this.weatherBackgroundImage,
      batteryBackgroundImage: batteryBackgroundImage ?? this.batteryBackgroundImage,
      dashboardBackgroundImage: dashboardBackgroundImage ?? this.dashboardBackgroundImage,
      moonPhaseBackgroundImage: moonPhaseBackgroundImage ?? this.moonPhaseBackgroundImage,
      photoWidgetImage: photoWidgetImage ?? this.photoWidgetImage,
    );
  }

  Map<String, dynamic> toJson() => {
        'selectedClock': selectedClock.name,
        'selectedAmbient': selectedAmbient.name,
        'accentColorHex': accentColorHex,
        'backgroundColorHex': backgroundColorHex,
        'showSeconds': showSeconds,
        'use24HourFormat': use24HourFormat,
        'timeOfDayReactivity': timeOfDayReactivity,
        'dashboardSlots': dashboardSlots.map((s) => s.toJson()).toList(),
        'isPro': isPro,
        'temperatureUnit': temperatureUnit,
        'calendarAccentHex': calendarAccentHex,
        'weatherAccentHex': weatherAccentHex,
        'batteryAccentHex': batteryAccentHex,
        'dashboardPreset': dashboardPreset,
        'dashboardAccentHex': dashboardAccentHex,
        'savedDashboards':
            savedDashboards.map((s) => s.toJson()).toList(),
        'calendarBackgroundHex': calendarBackgroundHex,
        'calendarAmbient': calendarAmbient.name,
        'weatherBackgroundHex': weatherBackgroundHex,
        'weatherAmbient': weatherAmbient.name,
        'batteryBackgroundHex': batteryBackgroundHex,
        'batteryAmbient': batteryAmbient.name,
        'dashboardBackgroundHex': dashboardBackgroundHex,
        'dashboardAmbient': dashboardAmbient.name,
        'moonPhaseAccentHex': moonPhaseAccentHex,
        'moonPhaseBackgroundHex': moonPhaseBackgroundHex,
        'moonPhaseAmbient': moonPhaseAmbient.name,
        'clockBackgroundImage': clockBackgroundImage,
        'calendarBackgroundImage': calendarBackgroundImage,
        'weatherBackgroundImage': weatherBackgroundImage,
        'batteryBackgroundImage': batteryBackgroundImage,
        'dashboardBackgroundImage': dashboardBackgroundImage,
        'moonPhaseBackgroundImage': moonPhaseBackgroundImage,
        'photoWidgetImage': photoWidgetImage,
      };

  String toJsonString() => jsonEncode(toJson());

  factory WidgetSettings.fromJson(Map<String, dynamic> json) {
    return WidgetSettings(
      selectedClock: ClockStyle.values
              .where((e) => e.name == (json['selectedClock'] as String?))
              .firstOrNull ??
          ClockStyle.minimalDigital,
      selectedAmbient: AmbientMode.values
              .where((e) => e.name == (json['selectedAmbient'] as String?))
              .firstOrNull ??
          AmbientMode.none,
      accentColorHex: json['accentColorHex'] as String? ?? 'FFFFFFFF',
      backgroundColorHex:
          json['backgroundColorHex'] as String? ?? 'FF1A237E',
      showSeconds: json['showSeconds'] as bool? ?? false,
      use24HourFormat: json['use24HourFormat'] as bool? ?? true,
      timeOfDayReactivity: json['timeOfDayReactivity'] as bool? ?? false,
      dashboardSlots: (json['dashboardSlots'] as List<dynamic>?)
              ?.map(
                  (e) => DashboardSlot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isPro: json['isPro'] as bool? ?? false,
      temperatureUnit: json['temperatureUnit'] as String? ?? 'celsius',
      calendarAccentHex: json['calendarAccentHex'] as String? ?? '',
      weatherAccentHex: json['weatherAccentHex'] as String? ?? '',
      batteryAccentHex: json['batteryAccentHex'] as String? ?? '',
      dashboardPreset: json['dashboardPreset'] as String? ?? 'all',
      dashboardAccentHex: json['dashboardAccentHex'] as String? ?? '',
      savedDashboards: (json['savedDashboards'] as List<dynamic>?)
              ?.map((e) =>
                  SavedDashboard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      calendarBackgroundHex: json['calendarBackgroundHex'] as String? ?? '',
      calendarAmbient: AmbientMode.values
              .where((e) => e.name == (json['calendarAmbient'] as String?))
              .firstOrNull ?? AmbientMode.none,
      weatherBackgroundHex: json['weatherBackgroundHex'] as String? ?? '',
      weatherAmbient: AmbientMode.values
              .where((e) => e.name == (json['weatherAmbient'] as String?))
              .firstOrNull ?? AmbientMode.none,
      batteryBackgroundHex: json['batteryBackgroundHex'] as String? ?? '',
      batteryAmbient: AmbientMode.values
              .where((e) => e.name == (json['batteryAmbient'] as String?))
              .firstOrNull ?? AmbientMode.none,
      dashboardBackgroundHex: json['dashboardBackgroundHex'] as String? ?? '',
      dashboardAmbient: AmbientMode.values
              .where((e) => e.name == (json['dashboardAmbient'] as String?))
              .firstOrNull ?? AmbientMode.none,
      moonPhaseAccentHex: json['moonPhaseAccentHex'] as String? ?? '',
      moonPhaseBackgroundHex: json['moonPhaseBackgroundHex'] as String? ?? '',
      moonPhaseAmbient: AmbientMode.values
              .where((e) => e.name == (json['moonPhaseAmbient'] as String?))
              .firstOrNull ??
          AmbientMode.none,
      clockBackgroundImage: json['clockBackgroundImage'] as String? ?? '',
      calendarBackgroundImage: json['calendarBackgroundImage'] as String? ?? '',
      weatherBackgroundImage: json['weatherBackgroundImage'] as String? ?? '',
      batteryBackgroundImage: json['batteryBackgroundImage'] as String? ?? '',
      dashboardBackgroundImage: json['dashboardBackgroundImage'] as String? ?? '',
      moonPhaseBackgroundImage: json['moonPhaseBackgroundImage'] as String? ?? '',
      photoWidgetImage: json['photoWidgetImage'] as String? ?? '',
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
        DashboardSlot(type: DashboardSlotType.clock, position: 0, enabled: false),
        DashboardSlot(type: DashboardSlotType.calendar, position: 1),
        DashboardSlot(type: DashboardSlotType.weather, position: 2),
        DashboardSlot(type: DashboardSlotType.battery, position: 3),
        DashboardSlot(type: DashboardSlotType.moonPhase, position: 4, enabled: false),
        DashboardSlot(type: DashboardSlotType.photo, position: 5, enabled: false),
      ],
    );
  }
}
