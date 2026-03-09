import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../models/clock_style.dart';
import '../../shared/design_system.dart';
import '../../shared/time_of_day_colors.dart';

class PreviewScreen extends ConsumerWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('StandBy Preview')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'So sieht dein Widget in StandBy aus:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              // StandBy frame (landscape aspect ratio)
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: StandByColors.trueBlack,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: StandByColors.surfaceCard,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: _ClockPreview(
                    style: settings.selectedClock,
                    use24Hour: settings.use24HourFormat,
                    accentColorHex: settings.accentColorHex,
                    timeReactive: settings.timeOfDayReactivity,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                settings.selectedClock.displayName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: StandByColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Füge das Widget über den iOS Widget-Picker hinzu',
                style: TextStyle(
                  fontSize: 13,
                  color: StandByColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClockPreview extends StatelessWidget {
  const _ClockPreview({
    required this.style,
    required this.use24Hour,
    required this.accentColorHex,
    required this.timeReactive,
  });

  final ClockStyle style;
  final bool use24Hour;
  final String accentColorHex;
  final bool timeReactive;

  Color get _accent {
    final hex = int.tryParse(accentColorHex, radix: 16);
    if (hex != null) return Color(hex);
    return StandByColors.accent;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final effectiveAccent =
        timeReactive ? TimeOfDayColors.forNow() : _accent;

    return Container(
      color: StandByColors.trueBlack,
      child: Center(
        child: switch (style) {
          ClockStyle.minimalDigital => _MinimalDigitalPreview(
              now: now,
              use24Hour: use24Hour,
              accent: effectiveAccent,
            ),
          ClockStyle.flipClock => _FlipClockPreview(
              now: now,
              use24Hour: use24Hour,
              accent: effectiveAccent,
            ),
          ClockStyle.analogClassic => _AnalogPreview(accent: effectiveAccent),
          ClockStyle.gradientClock => _GradientClockPreview(
              now: now,
              use24Hour: use24Hour,
            ),
          ClockStyle.binaryClock => _BinaryClockPreview(
              now: now,
              accent: effectiveAccent,
            ),
        },
      ),
    );
  }
}

class _MinimalDigitalPreview extends StatelessWidget {
  const _MinimalDigitalPreview({
    required this.now,
    required this.use24Hour,
    required this.accent,
  });

  final DateTime now;
  final bool use24Hour;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final hour =
        use24Hour ? now.hour : (now.hour > 12 ? now.hour - 12 : now.hour);
    final time =
        '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final date =
        '${_weekday(now.weekday)}, ${now.day}. ${_month(now.month)}';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w100,
            color: accent,
            letterSpacing: 4,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: TextStyle(
            fontSize: 14,
            color: accent.withValues(alpha: 0.6),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _FlipClockPreview extends StatelessWidget {
  const _FlipClockPreview({
    required this.now,
    required this.use24Hour,
    required this.accent,
  });

  final DateTime now;
  final bool use24Hour;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final hour =
        use24Hour ? now.hour : (now.hour > 12 ? now.hour - 12 : now.hour);
    final h = hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _FlipDigit(digit: h[0], accent: accent),
        _FlipDigit(digit: h[1], accent: accent),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            ':',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w300,
              color: accent,
            ),
          ),
        ),
        _FlipDigit(digit: m[0], accent: accent),
        _FlipDigit(digit: m[1], accent: accent),
      ],
    );
  }
}

class _FlipDigit extends StatelessWidget {
  const _FlipDigit({required this.digit, required this.accent});

  final String digit;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Stack(
        children: [
          // Split line
          Positioned(
            left: 0,
            right: 0,
            top: 31,
            child: Container(height: 2, color: const Color(0xFF0A0A0A)),
          ),
          Center(
            child: Text(
              digit,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalogPreview extends StatelessWidget {
  const _AnalogPreview({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: CustomPaint(painter: _AnalogPainter(accent: accent)),
    );
  }
}

class _AnalogPainter extends CustomPainter {
  _AnalogPainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final now = DateTime.now();

    // Circle
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF222222)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Hour markers
    for (var i = 0; i < 12; i++) {
      final angle = (i * 30 - 90) * math.pi / 180;
      final outer = Offset(
        center.dx + (radius - 4) * math.cos(angle),
        center.dy + (radius - 4) * math.sin(angle),
      );
      final inner = Offset(
        center.dx + (radius - 12) * math.cos(angle),
        center.dy + (radius - 12) * math.sin(angle),
      );
      canvas.drawLine(
        outer,
        inner,
        Paint()
          ..color = accent.withValues(alpha: 0.5)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
    }

    // Hour hand
    final hourAngle =
        ((now.hour % 12) * 30 + now.minute * 0.5 - 90) * math.pi / 180;
    canvas.drawLine(
      center,
      Offset(
        center.dx + radius * 0.5 * math.cos(hourAngle),
        center.dy + radius * 0.5 * math.sin(hourAngle),
      ),
      Paint()
        ..color = accent
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    // Minute hand
    final minAngle = (now.minute * 6 - 90) * math.pi / 180;
    canvas.drawLine(
      center,
      Offset(
        center.dx + radius * 0.75 * math.cos(minAngle),
        center.dy + radius * 0.75 * math.sin(minAngle),
      ),
      Paint()
        ..color = accent
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    // Center dot
    canvas.drawCircle(center, 4, Paint()..color = accent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _GradientClockPreview extends StatelessWidget {
  const _GradientClockPreview({
    required this.now,
    required this.use24Hour,
  });

  final DateTime now;
  final bool use24Hour;

  @override
  Widget build(BuildContext context) {
    final colors = TimeOfDayColors.gradientForHour(now.hour);
    final hour =
        use24Hour ? now.hour : (now.hour > 12 ? now.hour - 12 : now.hour);
    final time =
        '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Text(
          time,
          style: const TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w200,
            color: Colors.white,
            letterSpacing: 6,
          ),
        ),
      ),
    );
  }
}

class _BinaryClockPreview extends StatelessWidget {
  const _BinaryClockPreview({
    required this.now,
    required this.accent,
  });

  final DateTime now;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final h = now.hour;
    final m = now.minute;
    final digits = [h ~/ 10, h % 10, m ~/ 10, m % 10];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < digits.length; i++) ...[
          if (i == 2) const SizedBox(width: 12),
          _BinaryColumn(value: digits[i], accent: accent),
          const SizedBox(width: 6),
        ],
      ],
    );
  }
}

class _BinaryColumn extends StatelessWidget {
  const _BinaryColumn({required this.value, required this.accent});

  final int value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var bit = 3; bit >= 0; bit--)
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (value >> bit) & 1 == 1
                  ? accent
                  : accent.withValues(alpha: 0.15),
            ),
          ),
      ],
    );
  }
}

String _weekday(int wd) => switch (wd) {
      1 => 'Mo',
      2 => 'Di',
      3 => 'Mi',
      4 => 'Do',
      5 => 'Fr',
      6 => 'Sa',
      7 => 'So',
      _ => '',
    };

String _month(int m) => switch (m) {
      1 => 'Jan',
      2 => 'Feb',
      3 => 'Mär',
      4 => 'Apr',
      5 => 'Mai',
      6 => 'Jun',
      7 => 'Jul',
      8 => 'Aug',
      9 => 'Sep',
      10 => 'Okt',
      11 => 'Nov',
      12 => 'Dez',
      _ => '',
    };
