import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:standby_hub/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../l10n/l10n_helpers.dart';
import '../../models/dashboard_slot.dart';
import '../../models/clock_style.dart';
import '../../models/ambient_mode.dart';
import '../../models/widget_family.dart';
import '../../shared/ambient_background_picker.dart';
import '../../shared/design_system.dart';
import '../../shared/ui_components.dart';
import '../../services/settings_service.dart';
import '../../services/widget_reload_service.dart';

class DashboardConfigScreen extends ConsumerStatefulWidget {
  const DashboardConfigScreen({super.key});

  @override
  ConsumerState<DashboardConfigScreen> createState() =>
      _DashboardConfigScreenState();
}

class _DashboardConfigScreenState
    extends ConsumerState<DashboardConfigScreen> {
  Uint8List? _photoBytes;
  Uint8List? _bgImageBytes;
  bool _imagePickLoading = false;
  final Map<DashboardSlotType, Uint8List> _slotBgImages = {};
  WidgetFamily _selectedFamily = WidgetFamily.large;

  @override
  void initState() {
    super.initState();
    _loadPhotoImage();
    _loadBgImage();
    _loadSlotBackgroundImages();
  }

  Future<void> _loadPhotoImage() async {
    final settings = ref.read(settingsProvider);
    if (settings.photoWidgetImage.isEmpty) return;
    final path = await ref.read(settingsServiceProvider).getBackgroundImagePath(settings.photoWidgetImage);
    if (path != null && mounted) {
      final bytes = await File(path).readAsBytes();
      if (mounted) setState(() => _photoBytes = bytes);
    }
  }

  Future<void> _loadBgImage([String? overrideFilename]) async {
    final settings = ref.read(settingsProvider);
    final filename = overrideFilename ?? settings.dashboardBackgroundImage;
    if (filename.isEmpty) return;
    if (overrideFilename == null && settings.dashboardAmbient != AmbientMode.image) return;
    final path = await ref.read(settingsServiceProvider).getBackgroundImagePath(filename);
    if (path == null || !mounted) return;
    final file = File(path);
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      if (mounted) setState(() => _bgImageBytes = bytes);
    }
  }

  /// Load per-widget background images for all slots that have image ambient mode
  Future<void> _loadSlotBackgroundImages() async {
    final settings = ref.read(settingsProvider);
    final svc = ref.read(settingsServiceProvider);

    final slotConfigs = <DashboardSlotType, (AmbientMode, String)>{
      DashboardSlotType.clock: (settings.selectedAmbient, settings.clockBackgroundImage),
      DashboardSlotType.calendar: (settings.calendarAmbient, settings.calendarBackgroundImage),
      DashboardSlotType.weather: (settings.weatherAmbient, settings.weatherBackgroundImage),
      DashboardSlotType.battery: (settings.batteryAmbient, settings.batteryBackgroundImage),
      DashboardSlotType.moonPhase: (settings.moonPhaseAmbient, settings.moonPhaseBackgroundImage),
    };

    for (final entry in slotConfigs.entries) {
      final (ambient, filename) = entry.value;
      if (ambient != AmbientMode.image || filename.isEmpty) continue;
      final path = await svc.getBackgroundImagePath(filename);
      if (path == null || !mounted) continue;
      final file = File(path);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        if (mounted) {
          setState(() => _slotBgImages[entry.key] = bytes);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    // Reactively load bg image when ambient mode changes to image
    if (settings.dashboardAmbient == AmbientMode.image &&
        settings.dashboardBackgroundImage.isNotEmpty &&
        _bgImageBytes == null) {
      _loadBgImage();
    }

    final slots = List<DashboardSlot>.from(settings.dashboardSlots)
      ..sort((a, b) => a.position.compareTo(b.position));
    final hasDashboardAccent = settings.dashboardAccentHex.isNotEmpty;
    final dashboardAccent = hasDashboardAccent
        ? StandByColorUtils.parseColor(settings.dashboardAccentHex)
        : StandByColorUtils.parseColor(settings.accentColorHex);
    final hasDashboardBg = settings.dashboardBackgroundHex.isNotEmpty;
    final dashboardBg = hasDashboardBg
        ? StandByColorUtils.parseColor(settings.dashboardBackgroundHex)
        : StandByColors.trueBlack;

    final l10n = AppLocalizations.of(context)!;

    // Ensure all slot types exist
    final allSlots = _ensureAllSlots(slots);

    // Build per-slot gradients from widget ambient settings
    final slotGradients = <DashboardSlotType, List<Color>>{};
    final slotAmbientMap = {
      DashboardSlotType.clock: (settings.selectedAmbient, settings.backgroundColorHex),
      DashboardSlotType.calendar: (settings.calendarAmbient, settings.calendarBackgroundHex),
      DashboardSlotType.weather: (settings.weatherAmbient, settings.weatherBackgroundHex),
      DashboardSlotType.battery: (settings.batteryAmbient, settings.batteryBackgroundHex),
      DashboardSlotType.moonPhase: (settings.moonPhaseAmbient, settings.moonPhaseBackgroundHex),
    };
    for (final entry in slotAmbientMap.entries) {
      final (ambient, bgHex) = entry.value;
      final g = ambientGradient(ambient, bgHex);
      if (g != null) slotGradients[entry.key] = g;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dashboardConfigTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Widget size selector
          SegmentedButton<WidgetFamily>(
            segments: [
              for (final family in WidgetFamily.values)
                ButtonSegment(
                  value: family,
                  label: Text(family.localizedName(l10n)),
                ),
            ],
            selected: {_selectedFamily},
            onSelectionChanged: (s) => setState(() => _selectedFamily = s.first),
            style: SegmentedButton.styleFrom(
              backgroundColor: StandByColors.surfaceDark,
              foregroundColor: StandByColors.textSecondary,
              selectedBackgroundColor: StandByColors.accent.withValues(alpha: 0.2),
              selectedForegroundColor: StandByColors.accent,
            ),
          ),
          const SizedBox(height: 12),

          // Live preview
          _DashboardPreview(
            slots: allSlots,
            accent: dashboardAccent,
            background: dashboardBg,
            ambient: settings.dashboardAmbient,
            backgroundColorHex: settings.dashboardBackgroundHex,
            bgImageBytes: _bgImageBytes,
            clockStyle: settings.selectedClock,
            photoBytes: _photoBytes,
            slotBgImages: _slotBgImages,
            slotGradients: slotGradients,
            selectedFamily: _selectedFamily,
          ),
          const SizedBox(height: 24),

          // -- Custom slots with reorder --
          SBSectionHeader(l10n.customComposition),
          const SizedBox(height: 4),
          Text(
            l10n.reorderHint,
            style: TextStyle(
              fontSize: 11,
              color: StandByColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),

          // ReorderableListView needs a fixed height
          SizedBox(
            height: allSlots.length * 64.0,
            child: ReorderableListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allSlots.length,
              onReorder: (oldIndex, newIndex) => _onReorder(allSlots, oldIndex, newIndex),
              itemBuilder: (context, index) {
                final slot = allSlots[index];
                return _SlotReorderRow(
                  key: ValueKey(slot.type.name),
                  slot: slot,
                  icon: _iconForSlot(slot.type),
                  subtitle: slot.type == DashboardSlotType.clock
                      ? l10n.yourClock(settings.selectedClock.localizedName(l10n))
                      : null,
                  onToggle: (v) => _toggleSlot(allSlots, slot.type, v),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // -- Farbe --
          SBSectionHeader(l10n.dashboardColor),
          const SizedBox(height: 12),

          if (settings.isPro) ...[
            SBSwitchRow(
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: dashboardAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
              ),
              title: l10n.customDashboardColor,
              subtitle: hasDashboardAccent
                  ? l10n.individual
                  : l10n.usesGlobalColor,
              value: hasDashboardAccent,
              onChanged: (v) async {
                await ref.read(settingsProvider.notifier).update(
                  (s) => s.copyWith(
                    dashboardAccentHex: v ? s.accentColorHex : '',
                  ),
                );
                await WidgetReloadService().reloadAllWidgets();
              },
            ),
            if (hasDashboardAccent) ...[
              const SizedBox(height: 8),
              SBColorPickerRow(
                label: l10n.chooseColor,
                currentColor: dashboardAccent,
                dialogTitle: l10n.dashboardAccentColor,
                onColorChanged: (picked) async {
                  await ref.read(settingsProvider.notifier).update(
                    (s) => s.copyWith(
                        dashboardAccentHex:
                            StandByColorUtils.colorToHex(picked)),
                  );
                  await WidgetReloadService().reloadAllWidgets();
                },
              ),
            ],
          ] else
            SBSettingRow(
              leading: const Icon(Icons.palette_rounded,
                  color: StandByColors.accent),
              title: l10n.customDashboardColor,
              trailing: const SBProBadge(),
              onTap: () => context.push('/pro'),
            ),

          const SizedBox(height: 24),

          // -- Ambient Hintergrund --
          SBSectionHeader(l10n.background),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AmbientMode.values.map((mode) {
              final isSelected = settings.dashboardAmbient == mode;
              final isLocked = mode.isPro && !settings.isPro;
              return AmbientBackgroundChip(
                mode: mode,
                isSelected: isSelected,
                isLocked: isLocked,
                isLoading: mode == AmbientMode.image && _imagePickLoading,
                hasImage: settings.dashboardBackgroundImage.isNotEmpty,
                onTap: () async {
                  if (isLocked) { context.push('/pro'); return; }
                  if (mode == AmbientMode.image) {
                    setState(() => _imagePickLoading = true);
                    try {
                      final filename = await pickAndSaveBackgroundImage(
                        widgetKey: 'dashboard',
                        settingsService: ref.read(settingsServiceProvider),
                        context: context,
                      );
                      if (filename == null) return;
                      await ref.read(settingsProvider.notifier).update(
                        (s) => s.copyWith(dashboardAmbient: mode, dashboardBackgroundImage: filename),
                      );
                      _loadBgImage(filename);
                    } finally {
                      if (mounted) setState(() => _imagePickLoading = false);
                    }
                  } else {
                    await ref.read(settingsProvider.notifier).update(
                      (s) => s.copyWith(dashboardAmbient: mode),
                    );
                  }
                  await WidgetReloadService().reloadAllWidgets();
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // -- Options --
          SBSectionHeader(l10n.options),
          const SizedBox(height: 12),
          SBSwitchRow(
            leading: const Icon(
              Icons.brightness_6_rounded,
              color: StandByColors.accent,
            ),
            title: l10n.timeOfDayReactivity,
            subtitle: l10n.timeOfDayReactivityDashboard,
            value: settings.timeOfDayReactivity,
            onChanged: (v) async {
              await ref.read(settingsProvider.notifier).update(
                    (s) => s.copyWith(timeOfDayReactivity: v),
                  );
              await WidgetReloadService().reloadAllWidgets();
            },
          ),

          const SizedBox(height: 16),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  List<DashboardSlot> _ensureAllSlots(List<DashboardSlot> existing) {
    final result = <DashboardSlot>[];
    final existingTypes = existing.map((s) => s.type).toSet();
    result.addAll(existing);
    for (final type in DashboardSlotType.values) {
      if (!existingTypes.contains(type)) {
        result.add(DashboardSlot(
          type: type,
          position: result.length,
          enabled: false,
        ));
      }
    }
    return result;
  }

  Future<void> _onReorder(List<DashboardSlot> currentSlots, int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) newIndex -= 1;
    final reordered = List<DashboardSlot>.from(currentSlots);
    final item = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, item);

    final updatedSlots = reordered.indexed.map((pair) {
      final (i, slot) = pair;
      return slot.copyWith(position: i);
    }).toList();

    await ref.read(settingsProvider.notifier).update(
          (s) => s.copyWith(
            dashboardSlots: updatedSlots,
            dashboardPreset: 'custom',
          ),
        );
    await WidgetReloadService().reloadAllWidgets();
  }

  Future<void> _toggleSlot(List<DashboardSlot> currentSlots, DashboardSlotType type, bool enabled) async {
    final updatedSlots = currentSlots.map((slot) {
      if (slot.type == type) {
        return slot.copyWith(enabled: enabled);
      }
      return slot;
    }).toList();

    await ref.read(settingsProvider.notifier).update(
          (s) => s.copyWith(
            dashboardSlots: updatedSlots,
            dashboardPreset: 'custom',
          ),
        );
    await WidgetReloadService().reloadAllWidgets();
  }

  IconData _iconForSlot(DashboardSlotType type) => switch (type) {
        DashboardSlotType.clock => Icons.access_time_rounded,
        DashboardSlotType.calendar => Icons.calendar_today_rounded,
        DashboardSlotType.weather => Icons.cloud_rounded,
        DashboardSlotType.battery => Icons.battery_full_rounded,
        DashboardSlotType.moonPhase => Icons.nightlight_round,
        DashboardSlotType.photo => Icons.image_rounded,
      };
}

// ---------------------------------------------------------------------------
// Reorderable Slot Row
// ---------------------------------------------------------------------------

class _SlotReorderRow extends StatelessWidget {
  final DashboardSlot slot;
  final IconData icon;
  final String? subtitle;
  final ValueChanged<bool> onToggle;

  const _SlotReorderRow({
    super.key,
    required this.slot,
    required this.icon,
    required this.subtitle,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 56,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: StandByColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: slot.enabled ? StandByColors.accent : StandByColors.textMuted,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.type.localizedName(l10n),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: StandByColors.textPrimary,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: StandByColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: slot.enabled,
            onChanged: onToggle,
            activeColor: StandByColors.accent,
          ),
          const SizedBox(width: 4),
          ReorderableDragStartListener(
            index: 0, // handled by parent
            child: const Icon(
              Icons.drag_handle,
              color: StandByColors.textMuted,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Preview
// ---------------------------------------------------------------------------

class _DashboardPreview extends StatelessWidget {
  final List<DashboardSlot> slots;
  final Color accent;
  final Color background;
  final AmbientMode ambient;
  final String backgroundColorHex;
  final Uint8List? bgImageBytes;
  final ClockStyle clockStyle;
  final Uint8List? photoBytes;
  final Map<DashboardSlotType, Uint8List> slotBgImages;
  final Map<DashboardSlotType, List<Color>> slotGradients;
  final WidgetFamily selectedFamily;

  const _DashboardPreview({
    required this.slots,
    required this.accent,
    required this.background,
    required this.ambient,
    required this.backgroundColorHex,
    this.bgImageBytes,
    required this.clockStyle,
    this.photoBytes,
    this.slotBgImages = const {},
    this.slotGradients = const {},
    required this.selectedFamily,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final enabled = slots.where((s) => s.enabled).toList()
      ..sort((a, b) => a.position.compareTo(b.position));
    final visible = enabled.take(selectedFamily.maxSlots).toList();

    final gradient = ambientGradient(ambient, backgroundColorHex);

    final content = visible.isEmpty
        ? Center(
            child: Text(l10n.noSlotsActive,
                style: const TextStyle(
                    color: StandByColors.textMuted, fontSize: 13)),
          )
        : Padding(
            padding: const EdgeInsets.all(10),
            child: LayoutBuilder(
              builder: (context, constraints) =>
                  _buildFamilyLayout(visible, constraints),
            ),
          );

    return SBPreviewContainer(
      height: selectedFamily == WidgetFamily.small ? 180 : 160,
      child: ambient == AmbientMode.image && bgImageBytes != null
          ? Stack(
              fit: StackFit.expand,
              children: [
                Image.memory(bgImageBytes!, fit: BoxFit.cover),
                Container(color: Colors.black.withValues(alpha: 0.5)),
                content,
              ],
            )
          : Container(
              decoration: BoxDecoration(
                color: background,
                gradient: gradient != null
                    ? LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
              child: content,
            ),
    );
  }

  Widget _buildFamilyLayout(
      List<DashboardSlot> visible, BoxConstraints constraints) {
    switch (selectedFamily) {
      case WidgetFamily.small:
        // Vertical compact list: icon + label per row
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < visible.length; i++) ...[
              if (i > 0) const SizedBox(height: 4),
              _SmallSlotRow(
                type: visible[i].type,
                accent: accent,
                clockStyle: clockStyle,
              ),
            ],
          ],
        );
      case WidgetFamily.medium:
        // Horizontal row, 4 slots max
        return Row(
          children: [
            for (var i = 0; i < visible.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: _SlotTile(
                    type: visible[i].type,
                    accent: accent,
                    clockStyle: clockStyle,
                    photoBytes: photoBytes,
                    bgImageBytes: slotBgImages[visible[i].type],
                    gradient: slotGradients[visible[i].type],
                  ),
                ),
              ),
            ],
          ],
        );
      case WidgetFamily.large:
        // 2-column grid
        final cols = visible.length <= 3 ? visible.length : (visible.length / 2).ceil();
        final rows = visible.length <= 3 ? 1 : 2;
        return Wrap(
          spacing: 6,
          runSpacing: 6,
          children: visible.map((slot) {
            final w = (constraints.maxWidth - (cols - 1) * 6) / cols;
            final h = rows == 1
                ? constraints.maxHeight
                : (constraints.maxHeight - 6) / 2;
            return SizedBox(
              width: w,
              height: h,
              child: _SlotTile(
                type: slot.type,
                accent: accent,
                clockStyle: clockStyle,
                photoBytes: photoBytes,
                bgImageBytes: slotBgImages[slot.type],
                gradient: slotGradients[slot.type],
              ),
            );
          }).toList(),
        );
    }
  }
}

class _SmallSlotRow extends StatelessWidget {
  final DashboardSlotType type;
  final Color accent;
  final ClockStyle clockStyle;

  const _SmallSlotRow({
    required this.type,
    required this.accent,
    required this.clockStyle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final icon = switch (type) {
      DashboardSlotType.clock => Icons.access_time_rounded,
      DashboardSlotType.calendar => Icons.calendar_today_rounded,
      DashboardSlotType.weather => Icons.wb_sunny_rounded,
      DashboardSlotType.battery => Icons.battery_full_rounded,
      DashboardSlotType.moonPhase => Icons.nightlight_round,
      DashboardSlotType.photo => Icons.image_rounded,
    };
    final label = switch (type) {
      DashboardSlotType.clock => '14:30',
      DashboardSlotType.calendar => 'Meeting',
      DashboardSlotType.weather => '22°',
      DashboardSlotType.battery => '85%',
      DashboardSlotType.moonPhase => l10n.moonFullMoon,
      DashboardSlotType.photo => l10n.widgetPhoto,
    };

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accent.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: accent, size: 16),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: accent,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotTile extends StatelessWidget {
  final DashboardSlotType type;
  final Color accent;
  final ClockStyle clockStyle;
  final Uint8List? photoBytes;
  final Uint8List? bgImageBytes;
  final List<Color>? gradient;

  const _SlotTile({
    required this.type,
    required this.accent,
    required this.clockStyle,
    this.photoBytes,
    this.bgImageBytes,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = switch (type) {
      DashboardSlotType.clock => clockStyle.localizedName(l10n),
      DashboardSlotType.calendar => l10n.widgetCalendar,
      DashboardSlotType.weather => l10n.widgetWeather,
      DashboardSlotType.battery => l10n.widgetBattery,
      DashboardSlotType.moonPhase => l10n.widgetMoonPhase,
      DashboardSlotType.photo => l10n.widgetPhoto,
    };

    // Photo slot: fill entire tile with image
    if (type == DashboardSlotType.photo && photoBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.memory(photoBytes!, fit: BoxFit.cover),
            Container(color: Colors.black.withValues(alpha: 0.35)),
            Center(
              child: Text(
                l10n.widgetPhoto,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final tileContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildContent(),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: (bgImageBytes != null || gradient != null) ? Colors.white70 : accent.withValues(alpha: 0.5),
            fontSize: 7,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );

    // Slot with background image
    if (bgImageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.memory(bgImageBytes!, fit: BoxFit.cover),
            Container(color: Colors.black.withValues(alpha: 0.45)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: tileContent,
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: gradient == null ? accent.withValues(alpha: 0.08) : null,
        gradient: gradient != null
            ? LinearGradient(colors: gradient!, begin: Alignment.topLeft, end: Alignment.bottomRight)
            : null,
        borderRadius: BorderRadius.circular(8),
        border: gradient == null ? Border.all(color: accent.withValues(alpha: 0.15)) : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: tileContent,
    );
  }

  Widget _buildContent() {
    switch (type) {
      case DashboardSlotType.clock:
        return Text(
          '14:30',
          style: TextStyle(
            color: accent,
            fontSize: 18,
            fontWeight: FontWeight.w300,
            fontFamily: 'Menlo',
          ),
        );
      case DashboardSlotType.calendar:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_rounded, color: accent, size: 14),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                'Meeting',
                style: TextStyle(color: accent, fontSize: 13, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      case DashboardSlotType.weather:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wb_sunny_rounded, color: accent, size: 16),
            const SizedBox(width: 4),
            Text(
              '22°',
              style: TextStyle(color: accent, fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        );
      case DashboardSlotType.battery:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '85%',
              style: TextStyle(color: accent, fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: accent.withValues(alpha: 0.15),
              ),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.85,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: accent,
                  ),
                ),
              ),
            ),
          ],
        );
      case DashboardSlotType.moonPhase:
        return Text(
          '\u{1F315}',
          style: const TextStyle(fontSize: 22),
        );
      case DashboardSlotType.photo:
        return Icon(Icons.photo_rounded, color: accent, size: 22);
    }
  }

}
