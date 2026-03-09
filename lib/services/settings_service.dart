import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/widget_settings.dart';

const _channel = MethodChannel('com.tmmr.standbyHub/settings');

class SettingsService {
  Future<void> saveSettings(WidgetSettings settings) async {
    await _channel.invokeMethod('saveSettings', {
      'json': settings.toJsonString(),
    });
  }

  Future<WidgetSettings> loadSettings() async {
    try {
      final json = await _channel.invokeMethod<String>('loadSettings');
      if (json != null && json.isNotEmpty) {
        return WidgetSettings.fromJsonString(json);
      }
    } on PlatformException {
      // First launch or no settings saved yet
    }
    return WidgetSettings.defaultSettings();
  }
}

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService();
});
