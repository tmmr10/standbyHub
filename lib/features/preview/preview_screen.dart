import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:standby_hub/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../l10n/l10n_helpers.dart';
import '../../models/clock_style.dart';
import '../../models/ambient_mode.dart';
import '../../models/dashboard_slot.dart';
import '../../models/widget_family.dart';
import '../../services/settings_service.dart';
import '../../shared/ambient_background_picker.dart';
import '../../shared/design_system.dart';
import '../../shared/time_of_day_colors.dart';
import '../../shared/ui_components.dart';

enum _PreviewTab { clock, calendar, weather, battery, moonPhase, photo, dashboard }

class PreviewScreen extends ConsumerStatefulWidget {
  const PreviewScreen({super.key});

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  _PreviewTab _tab = _PreviewTab.clock;
  WidgetFamily _selectedFamily = WidgetFamily.large;
  bool _showDefaults = false;
  Uint8List? _dashboardBgImageBytes;
  Uint8List? _photoBytes;
  Uint8List? _clockImageBytes;
  Uint8List? _calendarImageBytes;
  Uint8List? _weatherImageBytes;
  Uint8List? _batteryImageBytes;
  Uint8List? _moonPhaseImageBytes;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final settings = ref.read(settingsProvider);
    final svc = ref.read(settingsServiceProvider);

    // Dashboard background image
    if (settings.dashboardAmbient == AmbientMode.image && settings.dashboardBackgroundImage.isNotEmpty) {
      final path = await svc.getBackgroundImagePath(settings.dashboardBackgroundImage);
      if (path != null && mounted) {
        final file = File(path);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          if (mounted) setState(() => _dashboardBgImageBytes = bytes);
        }
      }
    }

    // Photo widget image
    if (settings.photoWidgetImage.isNotEmpty) {
      final path = await svc.getBackgroundImagePath(settings.photoWidgetImage);
      if (path != null && mounted) {
        final bytes = await File(path).readAsBytes();
        if (mounted) setState(() => _photoBytes = bytes);
      }
    }

    // Per-widget background images
    final widgetConfigs = <String, (AmbientMode, String, void Function(Uint8List))>{
      'clock': (settings.selectedAmbient, settings.clockBackgroundImage, (b) => _clockImageBytes = b),
      'calendar': (settings.calendarAmbient, settings.calendarBackgroundImage, (b) => _calendarImageBytes = b),
      'weather': (settings.weatherAmbient, settings.weatherBackgroundImage, (b) => _weatherImageBytes = b),
      'battery': (settings.batteryAmbient, settings.batteryBackgroundImage, (b) => _batteryImageBytes = b),
      'moonPhase': (settings.moonPhaseAmbient, settings.moonPhaseBackgroundImage, (b) => _moonPhaseImageBytes = b),
    };
    for (final entry in widgetConfigs.values) {
      final (ambient, filename, setter) = entry;
      if (ambient != AmbientMode.image || filename.isEmpty) continue;
      final path = await svc.getBackgroundImagePath(filename);
      if (path != null && mounted) {
        final file = File(path);
        if (await file.exists()) {
          setter(await file.readAsBytes());
        }
      }
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.previewTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Preview
            Container(
              width: _selectedFamily == WidgetFamily.small ? 180 : double.infinity,
              height: _selectedFamily == WidgetFamily.small ? 200 : 200,
              decoration: BoxDecoration(
                color: StandByColors.trueBlack,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: StandByColors.surfaceCard, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: _buildPreviewContent(settings),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _previewTitle(settings, l10n),
              style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600,
                color: StandByColors.textPrimary,
              ),
            ),
            if (_tab == _PreviewTab.clock && settings.selectedAmbient != AmbientMode.none)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '${l10n.previewBackground}: ${settings.selectedAmbient.localizedName(l10n)}',
                  style: const TextStyle(fontSize: 13, color: StandByColors.textSecondary),
                ),
              ),
            const SizedBox(height: 4),
            Text(
              _tab == _PreviewTab.dashboard
                  ? l10n.previewDashboardSubtitle
                  : _tab == _PreviewTab.photo
                      ? l10n.previewPhotoSubtitle
                      : l10n.previewWidgetSubtitle,
              style: const TextStyle(fontSize: 13, color: StandByColors.textMuted),
              textAlign: TextAlign.center,
            ),
            // Widget size selector (all tabs)
            const SizedBox(height: 16),
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
            // Defaults switch (all tabs)
            const SizedBox(height: 12),
            SBSwitchRow(
              leading: const Icon(Icons.tune_rounded, color: StandByColors.accent, size: 20),
              title: l10n.showDefaults,
              subtitle: l10n.showDefaultsSubtitle,
              value: _showDefaults,
              onChanged: (v) => setState(() => _showDefaults = v),
            ),
            const SizedBox(height: 28),
            // Tab grid — 2 rows × 4 columns
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.0,
              children: [
                for (final tab in _PreviewTab.values)
                  _TabGridItem(
                    icon: _tabIcon(tab),
                    label: _tabLabel(tab, l10n),
                    selected: _tab == tab,
                    onTap: () => setState(() => _tab = tab),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _tabLabel(_PreviewTab tab, AppLocalizations l10n) => switch (tab) {
        _PreviewTab.clock => l10n.previewTabClock,
        _PreviewTab.calendar => l10n.previewTabCalendar,
        _PreviewTab.weather => l10n.previewTabWeather,
        _PreviewTab.battery => l10n.previewTabBattery,
        _PreviewTab.moonPhase => l10n.previewTabMoon,
        _PreviewTab.photo => l10n.previewTabPhoto,
        _PreviewTab.dashboard => l10n.previewTabDashboard,
      };

  IconData _tabIcon(_PreviewTab tab) => switch (tab) {
        _PreviewTab.clock => Icons.access_time_rounded,
        _PreviewTab.calendar => Icons.calendar_today_rounded,
        _PreviewTab.weather => Icons.cloud_rounded,
        _PreviewTab.battery => Icons.battery_full_rounded,
        _PreviewTab.moonPhase => Icons.nightlight_round,
        _PreviewTab.photo => Icons.image_rounded,
        _PreviewTab.dashboard => Icons.dashboard_rounded,
      };

  String _previewTitle(dynamic settings, AppLocalizations l10n) => switch (_tab) {
        _PreviewTab.clock => settings.selectedClock.localizedName(l10n),
        _PreviewTab.calendar => l10n.previewNextEvent,
        _PreviewTab.weather => l10n.previewWeather,
        _PreviewTab.battery => l10n.previewBattery,
        _PreviewTab.moonPhase => l10n.previewMoonPhase,
        _PreviewTab.photo => l10n.previewPhoto,
        _PreviewTab.dashboard => l10n.previewSmartDashboard,
      };

  Widget _buildPreviewContent(dynamic settings) {
    final now = DateTime.now();

    final defaults = _showDefaults;
    const defaultAccent = Colors.white;

    Color resolveAccent(String hex) {
      if (defaults) return defaultAccent;
      if (settings.timeOfDayReactivity) return TimeOfDayColors.forNow();
      return StandByColorUtils.parseColor(hex.isEmpty ? settings.accentColorHex : hex);
    }

    final calendarAccent = resolveAccent(settings.calendarAccentHex);
    final weatherAccent = resolveAccent(settings.weatherAccentHex);
    final batteryAccent = resolveAccent(settings.batteryAccentHex);
    final moonAccent = resolveAccent(settings.moonPhaseAccentHex);
    final photoAccent = resolveAccent(settings.accentColorHex);

    final dashboardAccentHex = defaults
        ? ''
        : (settings.dashboardAccentHex.isEmpty
            ? settings.accentColorHex
            : settings.dashboardAccentHex);
    final dashboardAccent = defaults
        ? defaultAccent
        : resolveAccent(dashboardAccentHex);
    final dashboardBg = defaults
        ? StandByColors.trueBlack
        : (settings.dashboardBackgroundHex.isNotEmpty
            ? StandByColorUtils.parseColor(settings.dashboardBackgroundHex)
            : StandByColors.trueBlack);
    final dashboardAmbient = defaults ? AmbientMode.none : settings.dashboardAmbient;
    final dashboardGradient = ambientGradient(dashboardAmbient, settings.dashboardBackgroundHex);

    final family = _selectedFamily;

    return switch (_tab) {
      _PreviewTab.clock => _ClockWithBackgroundPreview(
          style: settings.selectedClock,
          ambient: defaults ? AmbientMode.none : settings.selectedAmbient,
          use24Hour: settings.use24HourFormat,
          accentColorHex: defaults ? 'FFFFFFFF' : settings.accentColorHex,
          backgroundColorHex: settings.backgroundColorHex,
          timeReactive: defaults ? false : settings.timeOfDayReactivity,
          imageBytes: defaults ? null : _clockImageBytes,
          family: family,
        ),
      _PreviewTab.calendar => _SingleWidgetPreview(
          ambient: defaults ? AmbientMode.none : settings.calendarAmbient,
          gradient: defaults ? null : ambientGradient(settings.calendarAmbient, settings.calendarBackgroundHex),
          imageBytes: defaults ? null : _calendarImageBytes,
          child: _CalendarPreviewContent(accent: calendarAccent, now: now, family: family),
        ),
      _PreviewTab.weather => _SingleWidgetPreview(
          ambient: defaults ? AmbientMode.none : settings.weatherAmbient,
          gradient: defaults ? null : ambientGradient(settings.weatherAmbient, settings.weatherBackgroundHex),
          imageBytes: defaults ? null : _weatherImageBytes,
          child: _WeatherPreviewContent(
            accent: weatherAccent,
            isCelsius: settings.temperatureUnit == 'celsius',
            family: family,
          ),
        ),
      _PreviewTab.battery => _SingleWidgetPreview(
          ambient: defaults ? AmbientMode.none : settings.batteryAmbient,
          gradient: defaults ? null : ambientGradient(settings.batteryAmbient, settings.batteryBackgroundHex),
          imageBytes: defaults ? null : _batteryImageBytes,
          child: _BatteryPreviewContent(accent: batteryAccent, family: family),
        ),
      _PreviewTab.moonPhase => _SingleWidgetPreview(
          ambient: defaults ? AmbientMode.none : settings.moonPhaseAmbient,
          gradient: defaults ? null : ambientGradient(settings.moonPhaseAmbient, settings.moonPhaseBackgroundHex),
          imageBytes: defaults ? null : _moonPhaseImageBytes,
          child: _MoonPhasePreviewContent(accent: moonAccent, family: family),
        ),
      _PreviewTab.photo => _SingleWidgetPreview(
          child: _PhotoPreviewContent(accent: photoAccent, photoBytes: _photoBytes),
        ),
      _PreviewTab.dashboard => _DashboardPreviewWithBg(
          slots: settings.dashboardSlots,
          accent: dashboardAccent,
          background: dashboardBg,
          gradient: dashboardGradient,
          bgImageBytes: defaults ? null : _dashboardBgImageBytes,
          ambient: dashboardAmbient,
          timeReactive: defaults ? false : settings.timeOfDayReactivity,
          selectedFamily: _selectedFamily,
        ),
    };
  }
}

// =============================================================================
// TAB CHIP
// =============================================================================

class _TabGridItem extends StatelessWidget {
  const _TabGridItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? StandByColors.accent : StandByColors.textMuted;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: selected
                  ? StandByColors.accent.withValues(alpha: 0.15)
                  : StandByColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SINGLE WIDGET PREVIEWS (Calendar, Weather, Battery)
// =============================================================================

class _SingleWidgetPreview extends StatelessWidget {
  const _SingleWidgetPreview({
    required this.child,
    this.ambient = AmbientMode.none,
    this.gradient,
    this.imageBytes,
  });
  final Widget child;
  final AmbientMode ambient;
  final List<Color>? gradient;
  final Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(20),
      child: child,
    );
    if (ambient == AmbientMode.image && imageBytes != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(imageBytes!, fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.5)),
          content,
        ],
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: StandByColors.trueBlack,
        gradient: gradient != null
            ? LinearGradient(colors: gradient!, begin: Alignment.topLeft, end: Alignment.bottomRight)
            : null,
      ),
      child: content,
    );
  }
}

class _CalendarPreviewContent extends StatelessWidget {
  const _CalendarPreviewContent({required this.accent, required this.now, this.family = WidgetFamily.large});
  final Color accent;
  final DateTime now;
  final WidgetFamily family;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (family == WidgetFamily.small) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, color: accent, size: 20),
          const SizedBox(height: 4),
          Text('${now.day}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: accent)),
          Text(_month(now.month).toUpperCase(), style: const TextStyle(fontSize: 10, color: StandByColors.textSecondary)),
        ],
      );
    }

    if (family == WidgetFamily.medium) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, color: accent, size: 24),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.previewEventTitle, style: TextStyle(color: StandByColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
              Text(l10n.previewEventTime, style: TextStyle(color: accent, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${now.day}', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: accent)),
            Text(_month(now.month).toUpperCase(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: StandByColors.textSecondary)),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.previewEventTitle, style: TextStyle(color: StandByColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time, color: accent, size: 16),
                const SizedBox(width: 6),
                Text(l10n.previewEventTime, style: TextStyle(color: accent, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _WeatherPreviewContent extends StatelessWidget {
  const _WeatherPreviewContent({required this.accent, required this.isCelsius, this.family = WidgetFamily.large});
  final Color accent;
  final bool isCelsius;
  final WidgetFamily family;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final temp = isCelsius ? '22°' : '72°';

    if (family == WidgetFamily.small) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 24),
          const SizedBox(height: 4),
          Text(temp, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: accent)),
        ],
      );
    }

    if (family == WidgetFamily.medium) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 28),
          const SizedBox(width: 12),
          Text(isCelsius ? '22°C' : '72°F', style: TextStyle(color: accent, fontSize: 26, fontWeight: FontWeight.bold)),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 40),
        const SizedBox(width: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isCelsius ? '22°C' : '72°F', style: const TextStyle(color: StandByColors.textPrimary, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(l10n.previewCurrentWeather, style: TextStyle(color: StandByColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 2),
            Text(isCelsius ? 'H: 25°  L: 18°' : 'H: 77°  L: 64°', style: TextStyle(color: accent, fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}

class _BatteryPreviewContent extends StatelessWidget {
  const _BatteryPreviewContent({required this.accent, this.family = WidgetFamily.large});
  final Color accent;
  final WidgetFamily family;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (family == WidgetFamily.small) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.battery_full, color: accent, size: 24),
          const SizedBox(height: 4),
          Text('85%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: accent)),
        ],
      );
    }

    if (family == WidgetFamily.medium) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.battery_charging_full_rounded, color: accent, size: 28),
          const SizedBox(width: 12),
          const Text('85%', style: TextStyle(color: StandByColors.textPrimary, fontSize: 26, fontWeight: FontWeight.bold)),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 32,
          height: 80,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 32,
                height: 80,
                decoration: BoxDecoration(
                  color: StandByColors.surfaceCard,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Container(
                width: 32,
                height: 80 * 0.85,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('85%', style: TextStyle(color: StandByColors.textPrimary, fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.battery_charging_full_rounded, color: accent, size: 18),
                const SizedBox(width: 6),
                Text(l10n.previewBatteryLabel, style: TextStyle(color: StandByColors.textSecondary, fontSize: 14)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// =============================================================================
// MOON PHASE PREVIEW
// =============================================================================

class _MoonPhasePreviewContent extends StatelessWidget {
  const _MoonPhasePreviewContent({required this.accent, this.family = WidgetFamily.large});
  final Color accent;
  final WidgetFamily family;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (family == WidgetFamily.small) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('\u{1F315}', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 4),
          Text(l10n.previewFullMoon, style: TextStyle(fontSize: 12, color: accent, fontWeight: FontWeight.w600)),
        ],
      );
    }

    if (family == WidgetFamily.medium) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('\u{1F315}', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.previewFullMoon, style: TextStyle(color: StandByColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              Text(l10n.previewCurrentMoonPhase, style: TextStyle(color: StandByColors.textSecondary, fontSize: 11)),
            ],
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('\u{1F315}', style: TextStyle(fontSize: 52)),
        const SizedBox(width: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.previewFullMoon, style: TextStyle(color: StandByColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(l10n.previewCurrentMoonPhase, style: TextStyle(color: StandByColors.textSecondary, fontSize: 14)),
          ],
        ),
      ],
    );
  }
}


// =============================================================================
// PHOTO PREVIEW
// =============================================================================

class _PhotoPreviewContent extends StatelessWidget {
  const _PhotoPreviewContent({required this.accent, this.photoBytes});
  final Color accent;
  final Uint8List? photoBytes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (photoBytes != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(photoBytes!, fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.3)),
          Center(
            child: Text(
              l10n.previewPhotoWidget,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_rounded, color: accent.withValues(alpha: 0.5), size: 48),
          const SizedBox(height: 8),
          Text(
            l10n.previewNoPhoto,
            style: TextStyle(color: StandByColors.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.previewChoosePhoto,
            style: TextStyle(color: StandByColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CLOCK WITH BACKGROUND
// =============================================================================

List<Color>? _ambientGradient(AmbientMode mode, String bgHex) {
  return switch (mode) {
    AmbientMode.none => null,
    AmbientMode.aurora => const [Color(0x8000E676), Color(0x6000B0FF), Color(0x407C4DFF), Color(0xFF000000)],
    AmbientMode.lava => const [Color(0x80FF6D00), Color(0x60FF1744), Color(0x40D50000), Color(0xFF000000)],
    AmbientMode.ocean => const [Color(0x8000B8D4), Color(0x600091EA), Color(0x401A237E), Color(0xFF000000)],
    AmbientMode.sunset => const [Color(0x80FF6F00), Color(0x60E91E63), Color(0x404A148C), Color(0xFF000000)],
    AmbientMode.forest => const [Color(0x801B5E20), Color(0x6000695C), Color(0x40004D40), Color(0xFF000000)],
    AmbientMode.nebula => const [Color(0x80AA00FF), Color(0x60E040FB), Color(0x40880E4F), Color(0xFF000000)],
    AmbientMode.custom => () {
      final c = StandByColorUtils.parseColor(bgHex);
      return [c.withValues(alpha: 0.6), c.withValues(alpha: 0.2), const Color(0xFF000000)];
    }(),
    AmbientMode.image => null,
  };
}

class _ClockWithBackgroundPreview extends StatelessWidget {
  const _ClockWithBackgroundPreview({
    required this.style,
    required this.ambient,
    required this.use24Hour,
    required this.accentColorHex,
    required this.backgroundColorHex,
    required this.timeReactive,
    this.imageBytes,
    this.family = WidgetFamily.large,
  });

  final ClockStyle style;
  final AmbientMode ambient;
  final bool use24Hour;
  final String accentColorHex;
  final String backgroundColorHex;
  final bool timeReactive;
  final Uint8List? imageBytes;
  final WidgetFamily family;

  Color get _accent {
    if (timeReactive) return TimeOfDayColors.forNow();
    return StandByColorUtils.parseColor(accentColorHex);
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _ambientGradient(ambient, backgroundColorHex);
    final now = DateTime.now();

    final scale = switch (family) {
      WidgetFamily.small => 0.55,
      WidgetFamily.medium => 0.75,
      WidgetFamily.large => 1.0,
    };

    final clockWidget = switch (style) {
      ClockStyle.minimalDigital => _MinimalDigitalPreview(now: now, use24Hour: use24Hour, accent: _accent),
      ClockStyle.flipClock => _FlipClockPreview(now: now, use24Hour: use24Hour, accent: _accent),
      ClockStyle.analogClassic => _AnalogPreview(accent: _accent),
      ClockStyle.binaryClock => _BinaryClockPreview(now: now, accent: _accent),
      ClockStyle.pixelArtClock => _PixelArtClockPreview(now: now, accent: _accent),
    };

    final scaledClock = scale < 1.0
        ? Transform.scale(scale: scale, child: clockWidget)
        : clockWidget;

    if (ambient == AmbientMode.image && imageBytes != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(imageBytes!, fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.5)),
          Center(child: scaledClock),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: StandByColors.trueBlack,
        gradient: gradient != null
            ? LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight)
            : null,
      ),
      child: Center(child: scaledClock),
    );
  }
}

// =============================================================================
// DASHBOARD PREVIEW
// =============================================================================

class _DashboardPreviewWithBg extends StatelessWidget {
  const _DashboardPreviewWithBg({
    required this.slots,
    required this.accent,
    required this.background,
    required this.ambient,
    required this.timeReactive,
    required this.selectedFamily,
    this.gradient,
    this.bgImageBytes,
  });

  final List<DashboardSlot> slots;
  final Color accent;
  final Color background;
  final AmbientMode ambient;
  final bool timeReactive;
  final WidgetFamily selectedFamily;
  final List<Color>? gradient;
  final Uint8List? bgImageBytes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final enabled = slots.where((s) => s.enabled).toList()
      ..sort((a, b) => a.position.compareTo(b.position));
    final visible = enabled.take(selectedFamily.maxSlots).toList();

    final content = Padding(
      padding: const EdgeInsets.all(12),
      child: _buildFamilyLayout(context, visible, l10n),
    );

    if (ambient == AmbientMode.image && bgImageBytes != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(bgImageBytes!, fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.5)),
          content,
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: background,
        gradient: gradient != null
            ? LinearGradient(
                colors: gradient!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
      ),
      child: content,
    );
  }

  Widget _buildFamilyLayout(
      BuildContext context, List<DashboardSlot> visible, AppLocalizations l10n) {
    if (visible.isEmpty) {
      return Center(
        child: Text(l10n.noSlotsActive,
            style: const TextStyle(color: StandByColors.textMuted, fontSize: 13)),
      );
    }

    switch (selectedFamily) {
      case WidgetFamily.small:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < visible.length; i++) ...[
              if (i > 0) const SizedBox(height: 4),
              _SmallSlotRow(type: visible[i].type, accent: accent),
            ],
          ],
        );
      case WidgetFamily.medium:
        return Row(
          children: [
            for (var i = 0; i < visible.length; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(child: _SlotCard(type: visible[i].type, accent: accent)),
            ],
          ],
        );
      case WidgetFamily.large:
        return LayoutBuilder(
          builder: (context, constraints) {
            final cols = visible.length <= 3 ? visible.length : (visible.length / 2).ceil();
            final rows = visible.length <= 3 ? 1 : 2;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: visible.map((slot) {
                final w = (constraints.maxWidth - (cols - 1) * 8) / cols;
                final h = rows == 1
                    ? constraints.maxHeight
                    : (constraints.maxHeight - 8) / 2;
                return SizedBox(
                  width: w,
                  height: h,
                  child: _SlotCard(type: slot.type, accent: accent),
                );
              }).toList(),
            );
          },
        );
    }
  }
}

class _SmallSlotRow extends StatelessWidget {
  const _SmallSlotRow({required this.type, required this.accent});
  final DashboardSlotType type;
  final Color accent;

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
    final now = DateTime.now();
    final label = switch (type) {
      DashboardSlotType.clock =>
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      DashboardSlotType.calendar => l10n.previewNextEvent,
      DashboardSlotType.weather => '22°',
      DashboardSlotType.battery => '85%',
      DashboardSlotType.moonPhase => l10n.previewFullMoon,
      DashboardSlotType.photo => l10n.previewPhoto,
    };

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: StandByColors.surfaceCard,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: accent, size: 16),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: StandByColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotCard extends StatelessWidget {
  const _SlotCard({required this.type, required this.accent});
  final DashboardSlotType type;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    return Container(
      decoration: BoxDecoration(
        color: StandByColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: switch (type) {
          DashboardSlotType.calendar => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, color: accent, size: 20),
                const SizedBox(height: 4),
                Text('${now.day}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: StandByColors.textPrimary)),
                Text(_month(now.month).toUpperCase(), style: const TextStyle(fontSize: 11, color: StandByColors.textSecondary)),
              ],
            ),
          DashboardSlotType.weather => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud, color: accent, size: 20),
                const SizedBox(height: 4),
                const Text('--°', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: StandByColors.textPrimary)),
                Text(l10n.previewWeather.toUpperCase(), style: TextStyle(fontSize: 11, color: StandByColors.textSecondary)),
              ],
            ),
          DashboardSlotType.battery => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.battery_full, color: accent, size: 20),
                const SizedBox(height: 4),
                const Text('85%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: StandByColors.textPrimary)),
                Text(l10n.previewBattery.toUpperCase(), style: TextStyle(fontSize: 11, color: StandByColors.textSecondary)),
              ],
            ),
          DashboardSlotType.clock => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time_rounded, color: accent, size: 20),
                const SizedBox(height: 4),
                Text(
                  '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: StandByColors.textPrimary),
                ),
                Text(l10n.previewTabClock.toUpperCase(), style: TextStyle(fontSize: 11, color: StandByColors.textSecondary)),
              ],
            ),
          DashboardSlotType.moonPhase => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.nightlight_round, color: accent, size: 20),
                const SizedBox(height: 4),
                const Text('\u{1F315}', style: TextStyle(fontSize: 22)),
                Text(l10n.previewTabMoon.toUpperCase(), style: TextStyle(fontSize: 11, color: StandByColors.textSecondary)),
              ],
            ),
          DashboardSlotType.photo => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_rounded, color: accent, size: 20),
                const SizedBox(height: 4),
                Text(l10n.previewPhoto, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: StandByColors.textPrimary)),
                Text(l10n.previewPhoto.toUpperCase(), style: TextStyle(fontSize: 11, color: StandByColors.textSecondary)),
              ],
            ),
        },
      ),
    );
  }
}

// =============================================================================
// CLOCK PREVIEWS
// =============================================================================

class _MinimalDigitalPreview extends StatelessWidget {
  const _MinimalDigitalPreview({required this.now, required this.use24Hour, required this.accent});
  final DateTime now; final bool use24Hour; final Color accent;

  @override
  Widget build(BuildContext context) {
    final hour = use24Hour ? now.hour : (now.hour > 12 ? now.hour - 12 : now.hour);
    final time = '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final date = '${_weekday(now.weekday)}, ${now.day}. ${_month(now.month)}';
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(time, style: TextStyle(fontSize: 64, fontWeight: FontWeight.w100, color: accent, letterSpacing: 4, height: 1)),
      const SizedBox(height: 4),
      Text(date, style: TextStyle(fontSize: 14, color: accent.withValues(alpha: 0.6), letterSpacing: 1)),
    ]);
  }
}

class _FlipClockPreview extends StatelessWidget {
  const _FlipClockPreview({required this.now, required this.use24Hour, required this.accent});
  final DateTime now; final bool use24Hour; final Color accent;

  @override
  Widget build(BuildContext context) {
    final hour = use24Hour ? now.hour : (now.hour > 12 ? now.hour - 12 : now.hour);
    final h = hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _FlipDigit(digit: h[0], accent: accent), _FlipDigit(digit: h[1], accent: accent),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(':', style: TextStyle(fontSize: 52, fontWeight: FontWeight.w300, color: accent))),
      _FlipDigit(digit: m[0], accent: accent), _FlipDigit(digit: m[1], accent: accent),
    ]);
  }
}

class _FlipDigit extends StatelessWidget {
  const _FlipDigit({required this.digit, required this.accent});
  final String digit; final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48, height: 68,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1.5),
        boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Stack(children: [
        // Upper half slightly lighter
        Positioned(left: 0, right: 0, top: 0, height: 33,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
            ),
          ),
        ),
        // Split line with shadow effect
        Positioned(left: 0, right: 0, top: 33,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(height: 1, color: const Color(0xFF000000)),
            Container(height: 1.5, color: const Color(0xFF0A0A0A)),
            Container(height: 0.5, color: const Color(0xFF252525)),
          ]),
        ),
        Center(child: Text(digit, style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: accent, height: 1))),
      ]),
    );
  }
}

class _AnalogPreview extends StatelessWidget {
  const _AnalogPreview({required this.accent});
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 160, height: 160, child: CustomPaint(painter: _AnalogPainter(accent: accent)));
  }
}

class _AnalogPainter extends CustomPainter {
  _AnalogPainter({required this.accent});
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final now = DateTime.now();

    // Outer ring
    canvas.drawCircle(center, radius, Paint()
      ..color = const Color(0xFF1A1A1A)..style = PaintingStyle.stroke..strokeWidth = 3);

    // Minute ticks
    for (var i = 0; i < 60; i++) {
      final angle = (i * 6 - 90) * math.pi / 180;
      final isHour = i % 5 == 0;
      final outerR = radius - 3;
      final innerR = isHour ? radius - 16 : radius - 8;
      canvas.drawLine(
        Offset(center.dx + outerR * math.cos(angle), center.dy + outerR * math.sin(angle)),
        Offset(center.dx + innerR * math.cos(angle), center.dy + innerR * math.sin(angle)),
        Paint()
          ..color = isHour ? accent.withValues(alpha: 0.7) : accent.withValues(alpha: 0.2)
          ..strokeWidth = isHour ? 2.5 : 1
          ..strokeCap = StrokeCap.round,
      );
    }

    // Hour hand
    final ha = ((now.hour % 12) * 30 + now.minute * 0.5 - 90) * math.pi / 180;
    canvas.drawLine(center, Offset(center.dx + radius * 0.48 * math.cos(ha), center.dy + radius * 0.48 * math.sin(ha)),
      Paint()..color = accent..strokeWidth = 4..strokeCap = StrokeCap.round);

    // Minute hand
    final ma = (now.minute * 6 - 90) * math.pi / 180;
    canvas.drawLine(center, Offset(center.dx + radius * 0.72 * math.cos(ma), center.dy + radius * 0.72 * math.sin(ma)),
      Paint()..color = accent..strokeWidth = 2.5..strokeCap = StrokeCap.round);

    // Center dot
    canvas.drawCircle(center, 5, Paint()..color = accent);
    canvas.drawCircle(center, 2, Paint()..color = const Color(0xFF0A0A0A));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _BinaryClockPreview extends StatelessWidget {
  const _BinaryClockPreview({required this.now, required this.accent});
  final DateTime now; final Color accent;

  @override
  Widget build(BuildContext context) {
    final digits = [now.hour ~/ 10, now.hour % 10, now.minute ~/ 10, now.minute % 10];
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      for (var i = 0; i < digits.length; i++) ...[
        if (i == 2) const SizedBox(width: 12),
        _BinaryColumn(value: digits[i], accent: accent),
        const SizedBox(width: 6),
      ],
    ]);
  }
}

class _BinaryColumn extends StatelessWidget {
  const _BinaryColumn({required this.value, required this.accent});
  final int value; final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      for (var bit = 3; bit >= 0; bit--)
        Container(width: 16, height: 16, margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(shape: BoxShape.circle,
            color: (value >> bit) & 1 == 1 ? accent : accent.withValues(alpha: 0.15))),
    ]);
  }
}

// =============================================================================
// PIXEL ART CLOCK PREVIEW
// =============================================================================

class _PixelArtClockPreview extends StatelessWidget {
  const _PixelArtClockPreview({required this.now, required this.accent});
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
    final hour = now.hour;
    final timeStr = '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final colors = _pixelColors(hour);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 160,
          height: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(flex: 5, child: Container(color: colors.sky)),
                    Expanded(flex: 2, child: _MountainStrip(color: colors.mountain)),
                    Expanded(flex: 3, child: Container(color: colors.ground)),
                  ],
                ),
                Positioned(left: 8, top: 4, child: Text(colors.icon, style: const TextStyle(fontSize: 20))),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          timeStr,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
            color: accent,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }
}

class _MountainStrip extends StatelessWidget {
  const _MountainStrip({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MountainPainter(color: color),
      child: Container(),
    );
  }
}

class _MountainPainter extends CustomPainter {
  _MountainPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.15, size.height * 0.3)
      ..lineTo(size.width * 0.3, size.height)
      ..lineTo(size.width * 0.55, size.height * 0.1)
      ..lineTo(size.width * 0.75, size.height)
      ..lineTo(size.width * 0.85, size.height * 0.4)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MountainPainter old) => old.color != color;
}

// =============================================================================
// HELPERS
// =============================================================================

String _weekday(int wd) => switch (wd) {
  1 => 'Mo', 2 => 'Di', 3 => 'Mi', 4 => 'Do', 5 => 'Fr', 6 => 'Sa', 7 => 'So', _ => '',
};

String _month(int m) => switch (m) {
  1 => 'Jan', 2 => 'Feb', 3 => 'Mär', 4 => 'Apr', 5 => 'Mai', 6 => 'Jun',
  7 => 'Jul', 8 => 'Aug', 9 => 'Sep', 10 => 'Okt', 11 => 'Nov', 12 => 'Dez', _ => '',
};
