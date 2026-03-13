import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:standby_hub/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../l10n/l10n_helpers.dart';
import '../../models/clock_style.dart';
import '../../models/ambient_mode.dart';
import '../../shared/design_system.dart';
import '../../shared/ui_components.dart';
import '../../shared/ambient_background_picker.dart';
import '../../services/settings_service.dart';
import '../../services/widget_reload_service.dart';

class ClockConfigScreen extends ConsumerStatefulWidget {
  const ClockConfigScreen({super.key});

  @override
  ConsumerState<ClockConfigScreen> createState() => _ClockConfigScreenState();
}

class _ClockConfigScreenState extends ConsumerState<ClockConfigScreen> {
  Uint8List? _imageBytes;
  bool _imagePickLoading = false;

  @override
  void initState() {
    super.initState();
    _loadImageBytes();
  }

  Future<void> _loadImageBytes() async {
    final settings = ref.read(settingsProvider);
    if (settings.selectedAmbient != AmbientMode.image || settings.clockBackgroundImage.isEmpty) return;
    final path = await ref.read(settingsServiceProvider).getBackgroundImagePath(settings.clockBackgroundImage);
    if (path == null || !mounted) return;
    final file = File(path);
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      if (mounted) setState(() => _imageBytes = bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isPro = settings.isPro;
    final accentColor = StandByColorUtils.parseColor(settings.accentColorHex);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.clockWidgetsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Hero Preview ──
          _ClockHeroPreview(
            style: settings.selectedClock,
            ambient: settings.selectedAmbient,
            backgroundColorHex: settings.backgroundColorHex,
            accentColor: accentColor,
            imageBytes: _imageBytes,
          ),
          const SizedBox(height: 24),

          // ── Clock Style ──
          SBSectionHeader(l10n.selectStyle),
          const SizedBox(height: 12),
          ...ClockStyle.values.map((style) {
            final isSelected = settings.selectedClock == style;
            final isLocked = style.isPro && !isPro;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ClockStyleTile(
                style: style,
                isSelected: isSelected,
                isLocked: isLocked,
                onTap: () async {
                  if (isLocked) {
                    context.push('/pro');
                    return;
                  }
                  await ref.read(settingsProvider.notifier).update(
                        (s) => s.copyWith(selectedClock: style),
                      );
                  await WidgetReloadService().reloadAllWidgets();
                },
              ),
            );
          }),

          // ── Background ──
          const SizedBox(height: 24),
          SBSectionHeader(l10n.background),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AmbientMode.values.map((mode) {
              final isSelected = settings.selectedAmbient == mode;
              final isLocked = mode.isPro && !isPro;
              return AmbientBackgroundChip(
                mode: mode,
                isSelected: isSelected,
                isLocked: isLocked,
                isLoading: mode == AmbientMode.image && _imagePickLoading,
                customColor: mode == AmbientMode.custom
                    ? StandByColorUtils.parseColor(settings.backgroundColorHex)
                    : null,
                onTap: () async {
                  if (isLocked) {
                    context.push('/pro');
                    return;
                  }
                  if (mode == AmbientMode.image) {
                    setState(() => _imagePickLoading = true);
                    try {
                      final filename = await pickAndSaveBackgroundImage(
                        widgetKey: 'clock',
                        settingsService: ref.read(settingsServiceProvider),
                        context: context,
                      );
                      if (filename == null) return;
                      await ref.read(settingsProvider.notifier).update(
                        (s) => s.copyWith(selectedAmbient: mode, clockBackgroundImage: filename),
                      );
                      _loadImageBytes();
                    } finally {
                      if (mounted) setState(() => _imagePickLoading = false);
                    }
                  } else {
                    await ref.read(settingsProvider.notifier).update(
                      (s) => s.copyWith(selectedAmbient: mode),
                    );
                  }
                  await WidgetReloadService().reloadAllWidgets();
                },
              );
            }).toList(),
          ),

          // Custom background color picker
          if (settings.selectedAmbient == AmbientMode.custom && isPro) ...[
            const SizedBox(height: 16),
            SBColorPickerRow(
              label: l10n.backgroundColor,
              currentColor:
                  StandByColorUtils.parseColor(settings.backgroundColorHex),
              onColorChanged: (color) async {
                final hex = StandByColorUtils.colorToHex(color);
                await ref.read(settingsProvider.notifier).update(
                      (s) => s.copyWith(backgroundColorHex: hex),
                    );
                await WidgetReloadService().reloadAllWidgets();
              },
            ),
          ],

          // ── Accent Color (Pro) ──
          const SizedBox(height: 24),
          SBSectionHeader(l10n.accentColor),
          const SizedBox(height: 12),
          if (isPro)
            SBColorPickerRow(
              label: l10n.clockAccentLabel,
              currentColor: accentColor,
              onColorChanged: (color) async {
                final hex = StandByColorUtils.colorToHex(color);
                await ref.read(settingsProvider.notifier).update(
                      (s) => s.copyWith(accentColorHex: hex),
                    );
                await WidgetReloadService().reloadAllWidgets();
              },
            )
          else
            SBSettingRow(
              leading: const Icon(Icons.palette_rounded,
                  color: StandByColors.accent),
              title: l10n.customAccentColor,
              trailing: const SBProBadge(),
              onTap: () => context.push('/pro'),
            ),

          // ── Options ──
          const SizedBox(height: 24),
          SBSectionHeader(l10n.options),
          const SizedBox(height: 12),
          SBSwitchRow(
            title: l10n.use24HourFormat,
            value: settings.use24HourFormat,
            onChanged: (v) async {
              await ref.read(settingsProvider.notifier).update(
                    (s) => s.copyWith(use24HourFormat: v),
                  );
              await WidgetReloadService().reloadAllWidgets();
            },
          ),
          const SizedBox(height: 8),
          SBSwitchRow(
            title: l10n.timeOfDayReactivity,
            subtitle: l10n.timeOfDayReactivitySubtitle,
            value: settings.timeOfDayReactivity,
            onChanged: (v) async {
              await ref.read(settingsProvider.notifier).update(
                    (s) => s.copyWith(timeOfDayReactivity: v),
                  );
              await WidgetReloadService().reloadAllWidgets();
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Preview
// ─────────────────────────────────────────────────────────────────────────────

class _ClockHeroPreview extends StatelessWidget {
  const _ClockHeroPreview({
    required this.style,
    required this.ambient,
    required this.backgroundColorHex,
    required this.accentColor,
    this.imageBytes,
  });

  final ClockStyle style;
  final AmbientMode ambient;
  final String backgroundColorHex;
  final Color accentColor;
  final Uint8List? imageBytes;

  List<Color>? get _ambientGradient => switch (ambient) {
        AmbientMode.none => null,
        AmbientMode.aurora => const [
            Color(0x8000E676), Color(0x6000B0FF), Color(0x407C4DFF), Color(0xFF000000),
          ],
        AmbientMode.lava => const [
            Color(0x80FF6D00), Color(0x60FF1744), Color(0x40D50000), Color(0xFF000000),
          ],
        AmbientMode.ocean => const [
            Color(0x8000B8D4), Color(0x600091EA), Color(0x401A237E), Color(0xFF000000),
          ],
        AmbientMode.sunset => const [
            Color(0x80FF6F00), Color(0x60E91E63), Color(0x404A148C), Color(0xFF000000),
          ],
        AmbientMode.forest => const [
            Color(0x801B5E20), Color(0x6000695C), Color(0x40004D40), Color(0xFF000000),
          ],
        AmbientMode.nebula => const [
            Color(0x80AA00FF), Color(0x60E040FB), Color(0x40880E4F), Color(0xFF000000),
          ],
        AmbientMode.custom => () {
            final c = StandByColorUtils.parseColor(backgroundColorHex);
            return [
              c.withValues(alpha: 0.6),
              c.withValues(alpha: 0.2),
              const Color(0xFF000000),
            ];
          }(),
        AmbientMode.image => null,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final gradient = _ambientGradient;
    final now = DateTime.now();
    final hour = now.hour;
    final h = hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    final timeStr = '$h:$m';

    final clockWidget = Center(
      child: switch (style) {
        ClockStyle.analogClassic => _MiniAnalogClock(accent: accentColor),
        ClockStyle.binaryClock => _MiniBinaryClock(now: now, accent: accentColor),
        ClockStyle.flipClock => _MiniFlipClock(h: h, m: m, accent: accentColor),
        ClockStyle.pixelArtClock => _MiniPixelArtClock(now: now, accent: accentColor),
        _ => Text(
              timeStr,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w200,
                color: accentColor,
                letterSpacing: 2,
              ),
            ),
      },
    );

    return SBPreviewContainer(
      height: 180,
      child: ambient == AmbientMode.image && imageBytes != null
          ? Stack(
              fit: StackFit.expand,
              children: [
                Image.memory(imageBytes!, fit: BoxFit.cover),
                Container(color: Colors.black.withValues(alpha: 0.5)),
                clockWidget,
              ],
            )
          : Container(
              decoration: BoxDecoration(
                color: StandByColors.trueBlack,
                gradient: gradient != null
                    ? LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
              child: clockWidget,
            ),
    );
  }
}

class _MiniAnalogClock extends StatelessWidget {
  const _MiniAnalogClock({required this.accent});
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 130,
      child: CustomPaint(painter: _MiniAnalogPainter(accent: accent)),
    );
  }
}

class _MiniAnalogPainter extends CustomPainter {
  _MiniAnalogPainter({required this.accent});
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final now = DateTime.now();

    // Outer ring
    canvas.drawCircle(center, radius, Paint()
      ..color = const Color(0xFF1A1A1A)..style = PaintingStyle.stroke..strokeWidth = 2.5);

    // Ticks
    for (var i = 0; i < 60; i++) {
      final angle = (i * 6 - 90) * math.pi / 180;
      final isHour = i % 5 == 0;
      final outerR = radius - 2;
      final innerR = isHour ? radius - 14 : radius - 7;
      canvas.drawLine(
        Offset(center.dx + outerR * math.cos(angle), center.dy + outerR * math.sin(angle)),
        Offset(center.dx + innerR * math.cos(angle), center.dy + innerR * math.sin(angle)),
        Paint()
          ..color = isHour ? accent.withValues(alpha: 0.7) : accent.withValues(alpha: 0.15)
          ..strokeWidth = isHour ? 2 : 0.8
          ..strokeCap = StrokeCap.round,
      );
    }

    // Hour hand
    final ha = ((now.hour % 12) * 30 + now.minute * 0.5 - 90) * math.pi / 180;
    canvas.drawLine(center, Offset(center.dx + radius * 0.45 * math.cos(ha), center.dy + radius * 0.45 * math.sin(ha)),
      Paint()..color = accent..strokeWidth = 3.5..strokeCap = StrokeCap.round);

    // Minute hand
    final ma = (now.minute * 6 - 90) * math.pi / 180;
    canvas.drawLine(center, Offset(center.dx + radius * 0.7 * math.cos(ma), center.dy + radius * 0.7 * math.sin(ma)),
      Paint()..color = accent..strokeWidth = 2..strokeCap = StrokeCap.round);

    // Center dot
    canvas.drawCircle(center, 4, Paint()..color = accent);
    canvas.drawCircle(center, 1.5, Paint()..color = const Color(0xFF0A0A0A));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _MiniFlipClock extends StatelessWidget {
  const _MiniFlipClock({required this.h, required this.m, required this.accent});
  final String h;
  final String m;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _MiniFlipDigit(digit: h[0], accent: accent),
      _MiniFlipDigit(digit: h[1], accent: accent),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(':', style: TextStyle(fontSize: 44, fontWeight: FontWeight.w300, color: accent)),
      ),
      _MiniFlipDigit(digit: m[0], accent: accent),
      _MiniFlipDigit(digit: m[1], accent: accent),
    ]);
  }
}

class _MiniFlipDigit extends StatelessWidget {
  const _MiniFlipDigit({required this.digit, required this.accent});
  final String digit;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40, height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1.5),
        boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 3, offset: Offset(0, 2))],
      ),
      child: Stack(children: [
        Positioned(left: 0, right: 0, top: 0, height: 27,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
            ),
          ),
        ),
        Positioned(left: 0, right: 0, top: 27,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(height: 1, color: const Color(0xFF000000)),
            Container(height: 1, color: const Color(0xFF0A0A0A)),
          ]),
        ),
        Center(child: Text(digit, style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: accent, height: 1))),
      ]),
    );
  }
}

class _MiniBinaryClock extends StatelessWidget {
  const _MiniBinaryClock({required this.now, required this.accent});
  final DateTime now;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final digits = [now.hour ~/ 10, now.hour % 10, now.minute ~/ 10, now.minute % 10];
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      for (var i = 0; i < digits.length; i++) ...[
        if (i == 2) const SizedBox(width: 10),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (var bit = 3; bit >= 0; bit--)
            Container(width: 14, height: 14, margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: (digits[i] >> bit) & 1 == 1 ? accent : accent.withValues(alpha: 0.15))),
        ]),
        const SizedBox(width: 5),
      ],
    ]);
  }
}

class _MiniPixelArtClock extends StatelessWidget {
  const _MiniPixelArtClock({required this.now, required this.accent});
  final DateTime now;
  final Color accent;

  ({Color sky, Color mountain, Color ground, String icon}) _pixelColors(int hour) {
    if (hour >= 6 && hour < 10) {
      return (sky: const Color(0xFFFF9A56), mountain: const Color(0xFF2D5016), ground: const Color(0xFF3A7D0A), icon: '🌅');
    }
    if (hour >= 10 && hour < 17) {
      return (sky: const Color(0xFF4FC3F7), mountain: const Color(0xFF2E7D32), ground: const Color(0xFF4CAF50), icon: '☀️');
    }
    if (hour >= 17 && hour < 20) {
      return (sky: const Color(0xFF2D1B4E), mountain: const Color(0xFF1A1A2E), ground: const Color(0xFF16213E), icon: '🌇');
    }
    return (sky: const Color(0xFF0D1B2A), mountain: const Color(0xFF1B2838), ground: const Color(0xFF1B2838), icon: '🌙');
  }

  @override
  Widget build(BuildContext context) {
    final colors = _pixelColors(now.hour);
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 140,
          height: 70,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Column(children: [
                  Expanded(flex: 5, child: Container(color: colors.sky)),
                  Expanded(flex: 2, child: Container(color: colors.mountain)),
                  Expanded(flex: 3, child: Container(color: colors.ground)),
                ]),
                Positioned(left: 6, top: 3, child: Text(colors.icon, style: const TextStyle(fontSize: 16))),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          timeStr,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
            color: accent,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Clock Style Tile
// ─────────────────────────────────────────────────────────────────────────────

class _ClockStyleTile extends StatelessWidget {
  const _ClockStyleTile({
    required this.style,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
  });

  final ClockStyle style;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;

  IconData get _icon => switch (style) {
        ClockStyle.flipClock => Icons.flip_rounded,
        ClockStyle.minimalDigital => Icons.text_fields_rounded,
        ClockStyle.analogClassic => Icons.watch_rounded,
        ClockStyle.binaryClock => Icons.grid_on_rounded,
        ClockStyle.pixelArtClock => Icons.grid_4x4_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: StandByColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? StandByColors.accent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(_icon, color: StandByColors.accent, size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style.localizedName(l10n),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: StandByColors.textPrimary,
                    ),
                  ),
                  Text(
                    style.localizedDescription(l10n),
                    style: const TextStyle(
                      fontSize: 12,
                      color: StandByColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isLocked) const SBProBadge(),
            if (isSelected && !isLocked)
              const Icon(Icons.check_circle, color: StandByColors.accent),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
