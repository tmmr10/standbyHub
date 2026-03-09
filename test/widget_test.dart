import 'package:flutter_test/flutter_test.dart';
import 'package:standby_hub/models/widget_settings.dart';
import 'package:standby_hub/models/clock_style.dart';
import 'package:standby_hub/models/ambient_mode.dart';
import 'package:standby_hub/models/dashboard_slot.dart';

void main() {
  group('WidgetSettings', () {
    test('default settings are valid', () {
      final settings = WidgetSettings.defaultSettings();
      expect(settings.selectedClock, ClockStyle.minimalDigital);
      expect(settings.selectedAmbient, AmbientMode.aurora);
      expect(settings.isPro, false);
      expect(settings.dashboardSlots.length, 3);
    });

    test('JSON round-trip preserves data', () {
      final original = WidgetSettings.defaultSettings();
      final json = original.toJsonString();
      final restored = WidgetSettings.fromJsonString(json);

      expect(restored.selectedClock, original.selectedClock);
      expect(restored.selectedAmbient, original.selectedAmbient);
      expect(restored.accentColorHex, original.accentColorHex);
      expect(restored.use24HourFormat, original.use24HourFormat);
      expect(restored.isPro, original.isPro);
      expect(restored.dashboardSlots.length, original.dashboardSlots.length);
    });

    test('copyWith creates modified copy', () {
      final settings = const WidgetSettings();
      final modified = settings.copyWith(
        selectedClock: ClockStyle.flipClock,
        isPro: true,
      );

      expect(modified.selectedClock, ClockStyle.flipClock);
      expect(modified.isPro, true);
      expect(modified.selectedAmbient, settings.selectedAmbient);
    });
  });

  group('DashboardSlot', () {
    test('JSON round-trip', () {
      const slot = DashboardSlot(
        type: DashboardSlotType.weather,
        enabled: true,
        position: 1,
      );
      final json = slot.toJson();
      final restored = DashboardSlot.fromJson(json);

      expect(restored.type, slot.type);
      expect(restored.enabled, slot.enabled);
      expect(restored.position, slot.position);
    });
  });
}
