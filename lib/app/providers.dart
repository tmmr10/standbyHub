import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/widget_settings.dart';
import '../services/settings_service.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, WidgetSettings>((ref) {
  return SettingsNotifier(ref.watch(settingsServiceProvider));
});

class SettingsNotifier extends StateNotifier<WidgetSettings> {
  SettingsNotifier(this._service) : super(WidgetSettings.defaultSettings()) {
    _load();
  }

  final SettingsService _service;

  Future<void> _load() async {
    state = await _service.loadSettings();
  }

  Future<void> update(WidgetSettings Function(WidgetSettings) updater) async {
    state = updater(state);
    await _service.saveSettings(state);
  }
}

final isProProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).isPro;
});
