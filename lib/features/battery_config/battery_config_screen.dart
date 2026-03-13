import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:standby_hub/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../models/ambient_mode.dart';
import '../../shared/ambient_background_picker.dart';
import '../../shared/design_system.dart';
import '../../shared/ui_components.dart';
import '../../services/settings_service.dart';
import '../../services/widget_reload_service.dart';

class BatteryConfigScreen extends ConsumerStatefulWidget {
  const BatteryConfigScreen({super.key});

  @override
  ConsumerState<BatteryConfigScreen> createState() => _BatteryConfigScreenState();
}

class _BatteryConfigScreenState extends ConsumerState<BatteryConfigScreen> {
  Uint8List? _imageBytes;
  bool _imagePickLoading = false;

  @override
  void initState() {
    super.initState();
    _loadImageBytes();
  }

  Future<void> _loadImageBytes() async {
    final settings = ref.read(settingsProvider);
    if (settings.batteryAmbient != AmbientMode.image || settings.batteryBackgroundImage.isEmpty) return;
    final path = await ref.read(settingsServiceProvider).getBackgroundImagePath(settings.batteryBackgroundImage);
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
    final hasCustomAccent = settings.batteryAccentHex.isNotEmpty;
    final accent = hasCustomAccent
        ? StandByColorUtils.parseColor(settings.batteryAccentHex)
        : StandByColorUtils.parseColor(settings.accentColorHex);

    final gradient = ambientGradient(settings.batteryAmbient, settings.batteryBackgroundHex);
    final l10n = AppLocalizations.of(context)!;

    final previewContent = Row(
      children: [
        const SizedBox(width: 20),
        Icon(Icons.battery_charging_full_rounded, color: accent, size: 32),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('85%', style: TextStyle(color: StandByColors.textPrimary, fontSize: 32, fontWeight: FontWeight.bold)),
            Text(l10n.batteryLabel, style: const TextStyle(color: StandByColors.textSecondary, fontSize: 13)),
          ],
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: SizedBox(
            width: 24,
            height: 60,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(decoration: BoxDecoration(color: StandByColors.surfaceCard, borderRadius: BorderRadius.circular(4))),
                FractionallySizedBox(
                  heightFactor: 0.85,
                  child: Container(decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(4))),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.batteryWidgetTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Preview
          SBPreviewContainer(
            height: 180,
            child: settings.batteryAmbient == AmbientMode.image && _imageBytes != null
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
              final isSelected = settings.batteryAmbient == mode;
              final isLocked = mode.isPro && !isPro;
              return AmbientBackgroundChip(
                mode: mode,
                isSelected: isSelected,
                isLocked: isLocked,
                isLoading: mode == AmbientMode.image && _imagePickLoading,
                customColor: mode == AmbientMode.custom
                    ? StandByColorUtils.parseColor(settings.batteryBackgroundHex)
                    : null,
                onTap: () async {
                  if (isLocked) { context.push('/pro'); return; }
                  if (mode == AmbientMode.image) {
                    setState(() => _imagePickLoading = true);
                    try {
                      final filename = await pickAndSaveBackgroundImage(
                        widgetKey: 'battery',
                        settingsService: ref.read(settingsServiceProvider),
                        context: context,
                      );
                      if (filename == null) return;
                      await ref.read(settingsProvider.notifier).update(
                        (s) => s.copyWith(batteryAmbient: mode, batteryBackgroundImage: filename),
                      );
                      _loadImageBytes();
                    } finally {
                      if (mounted) setState(() => _imagePickLoading = false);
                    }
                  } else {
                    await ref.read(settingsProvider.notifier).update(
                      (s) => s.copyWith(batteryAmbient: mode),
                    );
                  }
                  await WidgetReloadService().reloadAllWidgets();
                },
                hasImage: settings.batteryBackgroundImage.isNotEmpty,
              );
            }).toList(),
          ),

          if (settings.batteryAmbient == AmbientMode.custom && isPro) ...[
            const SizedBox(height: 16),
            SBColorPickerRow(
              label: l10n.backgroundColor,
              currentColor: StandByColorUtils.parseColor(
                settings.batteryBackgroundHex.isEmpty ? 'FF1A237E' : settings.batteryBackgroundHex,
              ),
              onColorChanged: (color) async {
                await ref.read(settingsProvider.notifier).update(
                  (s) => s.copyWith(batteryBackgroundHex: StandByColorUtils.colorToHex(color)),
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
              label: l10n.batteryAccentLabel,
              currentColor: accent,
              onColorChanged: (color) async {
                await ref.read(settingsProvider.notifier).update(
                  (s) => s.copyWith(batteryAccentHex: StandByColorUtils.colorToHex(color)),
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
            title: l10n.batteryInfoTitle,
            items: [
              SBInfoItem(icon: Icons.battery_full, text: l10n.batteryInfoLevel),
              SBInfoItem(icon: Icons.color_lens, text: l10n.batteryInfoColor),
              SBInfoItem(icon: Icons.bar_chart, text: l10n.batteryInfoBar),
            ],
          ),
        ],
      ),
    );
  }
}
