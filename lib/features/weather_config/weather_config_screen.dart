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

class WeatherConfigScreen extends ConsumerStatefulWidget {
  const WeatherConfigScreen({super.key});

  @override
  ConsumerState<WeatherConfigScreen> createState() => _WeatherConfigScreenState();
}

class _WeatherConfigScreenState extends ConsumerState<WeatherConfigScreen> {
  Uint8List? _imageBytes;
  bool _imagePickLoading = false;

  @override
  void initState() {
    super.initState();
    _loadImageBytes();
  }

  Future<void> _loadImageBytes() async {
    final settings = ref.read(settingsProvider);
    if (settings.weatherAmbient != AmbientMode.image || settings.weatherBackgroundImage.isEmpty) return;
    final path = await ref.read(settingsServiceProvider).getBackgroundImagePath(settings.weatherBackgroundImage);
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
    final hasCustomAccent = settings.weatherAccentHex.isNotEmpty;
    final accent = hasCustomAccent
        ? StandByColorUtils.parseColor(settings.weatherAccentHex)
        : StandByColorUtils.parseColor(settings.accentColorHex);
    final isCelsius = settings.temperatureUnit == 'celsius';
    final l10n = AppLocalizations.of(context)!;

    final gradient = ambientGradient(settings.weatherAmbient, settings.weatherBackgroundHex);

    final previewContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 20),
        const Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 36),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isCelsius ? '22°C' : '72°F', style: const TextStyle(color: StandByColors.textPrimary, fontSize: 32, fontWeight: FontWeight.bold)),
            Text(l10n.currentWeather, style: const TextStyle(color: StandByColors.textSecondary, fontSize: 13)),
          ],
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.weatherWidgetTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Preview
          SBPreviewContainer(
            height: 180,
            child: settings.weatherAmbient == AmbientMode.image && _imageBytes != null
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

          SBSectionHeader(l10n.settings),
          const SizedBox(height: 12),

          // Temperature unit
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'celsius', label: Text('°C')),
              ButtonSegment(value: 'fahrenheit', label: Text('°F')),
            ],
            selected: {settings.temperatureUnit},
            onSelectionChanged: (v) async {
              await ref.read(settingsProvider.notifier).update(
                (s) => s.copyWith(temperatureUnit: v.first),
              );
              await WidgetReloadService().reloadAllWidgets();
            },
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: StandByColors.accent.withValues(alpha: 0.2),
              selectedForegroundColor: StandByColors.accent,
              foregroundColor: StandByColors.textSecondary,
            ),
          ),

          // Background
          const SizedBox(height: 24),
          SBSectionHeader(l10n.background),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AmbientMode.values.map((mode) {
              final isSelected = settings.weatherAmbient == mode;
              final isLocked = mode.isPro && !isPro;
              return AmbientBackgroundChip(
                mode: mode,
                isSelected: isSelected,
                isLocked: isLocked,
                isLoading: mode == AmbientMode.image && _imagePickLoading,
                customColor: mode == AmbientMode.custom
                    ? StandByColorUtils.parseColor(settings.weatherBackgroundHex)
                    : null,
                onTap: () async {
                  if (isLocked) { context.push('/pro'); return; }
                  if (mode == AmbientMode.image) {
                    setState(() => _imagePickLoading = true);
                    try {
                      final filename = await pickAndSaveBackgroundImage(
                        widgetKey: 'weather',
                        settingsService: ref.read(settingsServiceProvider),
                        context: context,
                      );
                      if (filename == null) return;
                      await ref.read(settingsProvider.notifier).update(
                        (s) => s.copyWith(weatherAmbient: mode, weatherBackgroundImage: filename),
                      );
                      _loadImageBytes();
                    } finally {
                      if (mounted) setState(() => _imagePickLoading = false);
                    }
                  } else {
                    await ref.read(settingsProvider.notifier).update(
                      (s) => s.copyWith(weatherAmbient: mode),
                    );
                  }
                  await WidgetReloadService().reloadAllWidgets();
                },
                hasImage: settings.weatherBackgroundImage.isNotEmpty,
              );
            }).toList(),
          ),

          if (settings.weatherAmbient == AmbientMode.custom && isPro) ...[
            const SizedBox(height: 16),
            SBColorPickerRow(
              label: l10n.backgroundColor,
              currentColor: StandByColorUtils.parseColor(
                settings.weatherBackgroundHex.isEmpty ? 'FF1A237E' : settings.weatherBackgroundHex,
              ),
              onColorChanged: (color) async {
                await ref.read(settingsProvider.notifier).update(
                  (s) => s.copyWith(weatherBackgroundHex: StandByColorUtils.colorToHex(color)),
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
              label: l10n.weatherAccentLabel,
              currentColor: accent,
              onColorChanged: (color) async {
                await ref.read(settingsProvider.notifier).update(
                  (s) => s.copyWith(weatherAccentHex: StandByColorUtils.colorToHex(color)),
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
            title: l10n.weatherInfoTitle,
            items: [
              SBInfoItem(icon: Icons.thermostat, text: l10n.weatherInfoTemp),
              SBInfoItem(icon: Icons.cloud, text: l10n.weatherInfoIcon),
            ],
            footnote: l10n.weatherInfoFootnote,
          ),
        ],
      ),
    );
  }
}
