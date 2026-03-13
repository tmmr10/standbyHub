import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:standby_hub/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../l10n/l10n_helpers.dart';
import '../../models/ambient_mode.dart';
import '../../shared/design_system.dart';
import '../../shared/ui_components.dart';
import '../../shared/ambient_background_picker.dart';
import '../../services/settings_service.dart';
import '../../services/widget_reload_service.dart';

class MoonPhaseConfigScreen extends ConsumerStatefulWidget {
  const MoonPhaseConfigScreen({super.key});

  @override
  ConsumerState<MoonPhaseConfigScreen> createState() => _MoonPhaseConfigScreenState();
}

class _MoonPhaseConfigScreenState extends ConsumerState<MoonPhaseConfigScreen> {
  Uint8List? _imageBytes;
  bool _imagePickLoading = false;

  @override
  void initState() {
    super.initState();
    _loadImageBytes();
  }

  Future<void> _loadImageBytes() async {
    final settings = ref.read(settingsProvider);
    if (settings.moonPhaseAmbient != AmbientMode.image || settings.moonPhaseBackgroundImage.isEmpty) return;
    final path = await ref.read(settingsServiceProvider).getBackgroundImagePath(settings.moonPhaseBackgroundImage);
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
    final hasCustomAccent = settings.moonPhaseAccentHex.isNotEmpty;
    final accent = hasCustomAccent
        ? StandByColorUtils.parseColor(settings.moonPhaseAccentHex)
        : StandByColorUtils.parseColor(settings.accentColorHex);

    final l10n = AppLocalizations.of(context)!;

    final now = DateTime.now();
    final moonPhase = _calculateMoonPhase(now);
    final moonEmoji = _moonEmoji(moonPhase);
    final phaseName = _phaseName(moonPhase, l10n);
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');

    final gradient = _ambientGradient(settings.moonPhaseAmbient, settings.moonPhaseBackgroundHex);

    final previewContent = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(moonEmoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 4),
          Text(phaseName, style: TextStyle(fontSize: 13, color: accent.withValues(alpha: 0.6))),
          const SizedBox(height: 4),
          Text('$hour:$minute', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w200, color: accent, letterSpacing: 2)),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moonPhaseWidgetTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Preview
          SBPreviewContainer(
            height: 180,
            child: settings.moonPhaseAmbient == AmbientMode.image && _imageBytes != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(_imageBytes!, fit: BoxFit.cover),
                      Container(color: Colors.black.withValues(alpha: 0.5)),
                      previewContent,
                    ],
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: StandByColors.trueBlack,
                      gradient: gradient != null
                          ? LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight)
                          : null,
                    ),
                    child: previewContent,
                  ),
          ),
          const SizedBox(height: 24),

          // Background
          SBSectionHeader(l10n.background),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AmbientMode.values.map((mode) {
              final isSelected = settings.moonPhaseAmbient == mode;
              final isLocked = mode.isPro && !isPro;
              return AmbientBackgroundChip(
                mode: mode,
                isSelected: isSelected,
                isLocked: isLocked,
                isLoading: mode == AmbientMode.image && _imagePickLoading,
                customColor: mode == AmbientMode.custom
                    ? StandByColorUtils.parseColor(settings.moonPhaseBackgroundHex)
                    : null,
                onTap: () async {
                  if (isLocked) { context.push('/pro'); return; }
                  if (mode == AmbientMode.image) {
                    setState(() => _imagePickLoading = true);
                    try {
                      final filename = await pickAndSaveBackgroundImage(
                        widgetKey: 'moonPhase',
                        settingsService: ref.read(settingsServiceProvider),
                        context: context,
                      );
                      if (filename == null) return;
                      await ref.read(settingsProvider.notifier).update(
                        (s) => s.copyWith(moonPhaseAmbient: mode, moonPhaseBackgroundImage: filename),
                      );
                      _loadImageBytes();
                    } finally {
                      if (mounted) setState(() => _imagePickLoading = false);
                    }
                  } else {
                    await ref.read(settingsProvider.notifier).update(
                      (s) => s.copyWith(moonPhaseAmbient: mode),
                    );
                  }
                  await WidgetReloadService().reloadAllWidgets();
                },
              );
            }).toList(),
          ),

          if (settings.moonPhaseAmbient == AmbientMode.custom && isPro) ...[
            const SizedBox(height: 16),
            SBColorPickerRow(
              label: l10n.backgroundColor,
              currentColor: StandByColorUtils.parseColor(
                settings.moonPhaseBackgroundHex.isEmpty ? 'FF1A237E' : settings.moonPhaseBackgroundHex,
              ),
              onColorChanged: (color) async {
                await ref.read(settingsProvider.notifier).update(
                  (s) => s.copyWith(moonPhaseBackgroundHex: StandByColorUtils.colorToHex(color)),
                );
                await WidgetReloadService().reloadAllWidgets();
              },
            ),
          ],

          // Accent color
          const SizedBox(height: 24),
          SBSectionHeader(l10n.accentColor),
          const SizedBox(height: 12),
          if (isPro)
            SBColorPickerRow(
              label: l10n.moonAccentLabel,
              currentColor: accent,
              onColorChanged: (color) async {
                await ref.read(settingsProvider.notifier).update(
                  (s) => s.copyWith(moonPhaseAccentHex: StandByColorUtils.colorToHex(color)),
                );
                await WidgetReloadService().reloadAllWidgets();
              },
            )
          else
            SBSettingRow(
              leading: const Icon(Icons.palette_rounded, color: StandByColors.accent),
              title: l10n.customAccentColor,
              trailing: const SBProBadge(),
              onTap: () => context.push('/pro'),
            ),

          const SizedBox(height: 24),
          SBSectionHeader(l10n.info),
          const SizedBox(height: 12),
          SBInfoBox(
            title: l10n.moonInfoTitle,
            items: [
              SBInfoItem(icon: Icons.nightlight_round, text: l10n.moonInfoPhase),
              SBInfoItem(icon: Icons.label_outline, text: l10n.moonInfoName),
              SBInfoItem(icon: Icons.access_time, text: l10n.moonInfoTime),
            ],
          ),
        ],
      ),
    );
  }
}

List<Color>? _ambientGradient(AmbientMode mode, String bgHex) {
  return switch (mode) {
    AmbientMode.none => null,
    AmbientMode.aurora => const [Color(0x8000E676), Color(0x6000B0FF), Color(0x407C4DFF), Color(0xFF000000)],
    AmbientMode.lava => const [Color(0x80FF6D00), Color(0x60FF1744), Color(0x40D50000), Color(0xFF000000)],
    AmbientMode.ocean => const [Color(0x8000B8D4), Color(0x600091EA), Color(0x401A237E), Color(0xFF000000)],
    AmbientMode.sunset => const [Color(0x80FF6F00), Color(0x60E91E63), Color(0x404A148C), Color(0xFF000000)],
    AmbientMode.forest => const [Color(0x801B5E20), Color(0x6000695C), Color(0x40004D40), Color(0xFF000000)],
    AmbientMode.nebula => const [Color(0x80AA00FF), Color(0x60E040FB), Color(0x40880E4F), Color(0xFF000000)],
    AmbientMode.image => null,
    AmbientMode.custom => () {
      final c = StandByColorUtils.parseColor(bgHex.isEmpty ? 'FF1A237E' : bgHex);
      return [c.withValues(alpha: 0.6), c.withValues(alpha: 0.2), const Color(0xFF000000)];
    }(),
  };
}

double _calculateMoonPhase(DateTime now) {
  final reference = DateTime(2000, 1, 6, 18, 14);
  final days = now.difference(reference).inSeconds / 86400.0;
  final phase = (days % 29.53) / 29.53;
  return phase < 0 ? phase + 1 : phase;
}

String _moonEmoji(double p) {
  if (p < 0.0625) return '🌑';
  if (p < 0.1875) return '🌒';
  if (p < 0.3125) return '🌓';
  if (p < 0.4375) return '🌔';
  if (p < 0.5625) return '🌕';
  if (p < 0.6875) return '🌖';
  if (p < 0.8125) return '🌗';
  if (p < 0.9375) return '🌘';
  return '🌑';
}

String _phaseName(double p, AppLocalizations l10n) {
  return localizedMoonPhase(l10n, p);
}

