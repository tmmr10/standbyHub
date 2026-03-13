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

class CalendarConfigScreen extends ConsumerStatefulWidget {
  const CalendarConfigScreen({super.key});

  @override
  ConsumerState<CalendarConfigScreen> createState() => _CalendarConfigScreenState();
}

class _CalendarConfigScreenState extends ConsumerState<CalendarConfigScreen> {
  Uint8List? _imageBytes;
  bool _imagePickLoading = false;

  @override
  void initState() {
    super.initState();
    _loadImageBytes();
  }

  Future<void> _loadImageBytes() async {
    final settings = ref.read(settingsProvider);
    if (settings.calendarAmbient != AmbientMode.image || settings.calendarBackgroundImage.isEmpty) return;
    final path = await ref.read(settingsServiceProvider).getBackgroundImagePath(settings.calendarBackgroundImage);
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
    final hasCustomAccent = settings.calendarAccentHex.isNotEmpty;
    final accent = hasCustomAccent
        ? StandByColorUtils.parseColor(settings.calendarAccentHex)
        : StandByColorUtils.parseColor(settings.accentColorHex);

    final gradient = ambientGradient(settings.calendarAmbient, settings.calendarBackgroundHex);
    final l10n = AppLocalizations.of(context)!;

    final previewContent = Row(
      children: [
        const SizedBox(width: 20),
        Icon(Icons.calendar_today, color: accent, size: 32),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.previewEventTitle, style: const TextStyle(color: StandByColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(l10n.previewEventTime, style: TextStyle(color: accent, fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.calendarWidgetTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Preview
          SBPreviewContainer(
            height: 180,
            child: settings.calendarAmbient == AmbientMode.image && _imageBytes != null
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
              final isSelected = settings.calendarAmbient == mode;
              final isLocked = mode.isPro && !isPro;
              return AmbientBackgroundChip(
                mode: mode,
                isSelected: isSelected,
                isLocked: isLocked,
                isLoading: mode == AmbientMode.image && _imagePickLoading,
                customColor: mode == AmbientMode.custom
                    ? StandByColorUtils.parseColor(settings.calendarBackgroundHex)
                    : null,
                onTap: () async {
                  if (isLocked) { context.push('/pro'); return; }
                  if (mode == AmbientMode.image) {
                    setState(() => _imagePickLoading = true);
                    try {
                      final filename = await pickAndSaveBackgroundImage(
                        widgetKey: 'calendar',
                        settingsService: ref.read(settingsServiceProvider),
                        context: context,
                      );
                      if (filename == null) return;
                      await ref.read(settingsProvider.notifier).update(
                        (s) => s.copyWith(calendarAmbient: mode, calendarBackgroundImage: filename),
                      );
                      _loadImageBytes();
                    } finally {
                      if (mounted) setState(() => _imagePickLoading = false);
                    }
                  } else {
                    await ref.read(settingsProvider.notifier).update(
                      (s) => s.copyWith(calendarAmbient: mode),
                    );
                  }
                  await WidgetReloadService().reloadAllWidgets();
                },
                hasImage: settings.calendarBackgroundImage.isNotEmpty,
              );
            }).toList(),
          ),

          if (settings.calendarAmbient == AmbientMode.custom && isPro) ...[
            const SizedBox(height: 16),
            SBColorPickerRow(
              label: l10n.backgroundColor,
              currentColor: StandByColorUtils.parseColor(
                settings.calendarBackgroundHex.isEmpty ? 'FF1A237E' : settings.calendarBackgroundHex,
              ),
              onColorChanged: (color) async {
                await ref.read(settingsProvider.notifier).update(
                  (s) => s.copyWith(calendarBackgroundHex: StandByColorUtils.colorToHex(color)),
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
              label: l10n.calendarAccentLabel,
              currentColor: accent,
              onColorChanged: (color) async {
                await ref.read(settingsProvider.notifier).update(
                  (s) => s.copyWith(calendarAccentHex: StandByColorUtils.colorToHex(color)),
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
            title: l10n.calendarInfoTitle,
            items: [
              SBInfoItem(icon: Icons.event, text: l10n.calendarInfoEvent),
              SBInfoItem(icon: Icons.calendar_today, text: l10n.calendarInfoNoEvent),
            ],
            footnote: l10n.calendarInfoFootnote,
          ),
        ],
      ),
    );
  }
}
