import 'package:flutter/material.dart';
import 'package:standby_hub/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/l10n_helpers.dart';
import '../models/ambient_mode.dart';
import '../services/settings_service.dart';
import 'design_system.dart';

/// Reusable ambient gradient helper
List<Color>? ambientGradient(AmbientMode mode, String bgHex) {
  return switch (mode) {
    AmbientMode.none => null,
    AmbientMode.aurora => const [Color(0x8000E676), Color(0x6000B0FF), Color(0x407C4DFF), Color(0xFF000000)],
    AmbientMode.lava => const [Color(0x80FF6D00), Color(0x60FF1744), Color(0x40D50000), Color(0xFF000000)],
    AmbientMode.ocean => const [Color(0x8000B8D4), Color(0x600091EA), Color(0x401A237E), Color(0xFF000000)],
    AmbientMode.sunset => const [Color(0x80FF6F00), Color(0x60E91E63), Color(0x404A148C), Color(0xFF000000)],
    AmbientMode.forest => const [Color(0x801B5E20), Color(0x6000695C), Color(0x40004D40), Color(0xFF000000)],
    AmbientMode.nebula => const [Color(0x80AA00FF), Color(0x60E040FB), Color(0x40880E4F), Color(0xFF000000)],
    AmbientMode.custom => () {
      final c = StandByColorUtils.parseColor(bgHex.isEmpty ? 'FF1A237E' : bgHex);
      return [c.withValues(alpha: 0.6), c.withValues(alpha: 0.2), const Color(0xFF000000)];
    }(),
    AmbientMode.image => null,
  };
}

/// Reusable background chip for ambient mode selection
class AmbientBackgroundChip extends StatefulWidget {
  const AmbientBackgroundChip({
    super.key,
    required this.mode,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
    this.customColor,
    this.hasImage = false,
    this.isLoading = false,
  });

  final AmbientMode mode;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;
  final Color? customColor;
  final bool hasImage;
  final bool isLoading;

  @override
  State<AmbientBackgroundChip> createState() => _AmbientBackgroundChipState();
}

class _AmbientBackgroundChipState extends State<AmbientBackgroundChip> {
  double _scale = 1.0;

  List<Color>? get _gradient => switch (widget.mode) {
        AmbientMode.none => null,
        AmbientMode.aurora => const [Color(0xFF00E676), Color(0xFF00B0FF), Color(0xFF7C4DFF)],
        AmbientMode.lava => const [Color(0xFFFF6D00), Color(0xFFFF1744), Color(0xFFD50000)],
        AmbientMode.ocean => const [Color(0xFF00B8D4), Color(0xFF0091EA), Color(0xFF1A237E)],
        AmbientMode.sunset => const [Color(0xFFFF6F00), Color(0xFFE91E63), Color(0xFF4A148C)],
        AmbientMode.forest => const [Color(0xFF1B5E20), Color(0xFF00695C), Color(0xFF004D40)],
        AmbientMode.nebula => const [Color(0xFFAA00FF), Color(0xFFE040FB), Color(0xFF880E4F)],
        AmbientMode.custom => null,
        AmbientMode.image => null,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: widget.mode == AmbientMode.none
                ? StandByColors.trueBlack
                : (widget.mode == AmbientMode.custom ? widget.customColor : null),
            gradient: _gradient != null
                ? LinearGradient(colors: _gradient!, begin: Alignment.topLeft, end: Alignment.bottomRight)
                : null,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isSelected ? StandByColors.accent : StandByColors.surfaceCard,
              width: widget.isSelected ? 2.5 : 1.5,
            ),
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: StandByColors.accent,
                    ),
                  )
                : widget.isLocked
                    ? const Text('PRO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: StandByColors.proGold))
                    : widget.isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : widget.mode == AmbientMode.image
                            ? Icon(
                                widget.hasImage ? Icons.image : Icons.add_photo_alternate_outlined,
                                color: Colors.white70,
                                size: 20,
                              )
                            : Text(
                                widget.mode == AmbientMode.none ? l10n.backgroundOff : widget.mode.localizedName(l10n),
                                style: const TextStyle(fontSize: 9, color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
          ),
        ),
      ),
    );
  }
}

/// Helper to pick and save a background image for a widget.
/// Shows a loading overlay while processing the image.
Future<String?> pickAndSaveBackgroundImage({
  required String widgetKey,
  required SettingsService settingsService,
  required BuildContext context,
}) async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1024);
  if (picked == null) return null;
  if (!context.mounted) return null;
  return settingsService.saveBackgroundImage(picked.path, widgetKey);
}
