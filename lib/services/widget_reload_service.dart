import 'package:flutter/services.dart';

const _channel = MethodChannel('com.tmmr.standbyHub/widget');

class WidgetReloadService {
  Future<void> reloadAllWidgets() async {
    await _channel.invokeMethod('reloadAllWidgets');
  }

  Future<void> reloadWidget(String kind) async {
    await _channel.invokeMethod('reloadWidget', {'kind': kind});
  }
}
