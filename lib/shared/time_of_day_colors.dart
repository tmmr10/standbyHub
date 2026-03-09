import 'package:flutter/material.dart';

abstract class TimeOfDayColors {
  static const Map<int, Color> hourlyAccents = {
    0: Color(0xFF1A237E),  // Midnight — deep indigo
    1: Color(0xFF1A237E),
    2: Color(0xFF0D47A1),
    3: Color(0xFF0D47A1),
    4: Color(0xFF01579B),
    5: Color(0xFF006064),  // Pre-dawn — dark teal
    6: Color(0xFF00838F),  // Dawn
    7: Color(0xFFFF8F00),  // Sunrise — amber
    8: Color(0xFFFFA000),
    9: Color(0xFFFFB300),
    10: Color(0xFF00DDFF), // Morning — cyan
    11: Color(0xFF00DDFF),
    12: Color(0xFF00BCD4), // Noon
    13: Color(0xFF0097A7),
    14: Color(0xFF00838F),
    15: Color(0xFF00ACC1),
    16: Color(0xFF0097A7),
    17: Color(0xFFFF6F00), // Golden hour
    18: Color(0xFFE65100), // Sunset
    19: Color(0xFFBF360C),
    20: Color(0xFF4A148C), // Dusk — purple
    21: Color(0xFF311B92),
    22: Color(0xFF1A237E), // Night
    23: Color(0xFF1A237E),
  };

  static Color forHour(int hour) => hourlyAccents[hour.clamp(0, 23)]!;

  static Color forNow() => forHour(DateTime.now().hour);

  static List<Color> gradientForHour(int hour) {
    final base = forHour(hour);
    return [
      base.withValues(alpha: 0.8),
      base.withValues(alpha: 0.3),
      const Color(0xFF000000),
    ];
  }
}
