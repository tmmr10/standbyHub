import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

import 'design_system.dart';

/// Sentence-case section header (replaces uppercase labelSmall usage)
class SBSectionHeader extends StatelessWidget {
  const SBSectionHeader(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

/// Standard settings row with surfaceDark background, no Card wrapper
class SBSettingRow extends StatefulWidget {
  const SBSettingRow({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  State<SBSettingRow> createState() => _SBSettingRowState();
}

class _SBSettingRowState extends State<SBSettingRow> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTap != null ? (_) => setState(() => _scale = 0.95) : null,
      onTapUp: widget.onTap != null ? (_) => setState(() => _scale = 1.0) : null,
      onTapCancel: widget.onTap != null ? () => setState(() => _scale = 1.0) : null,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: StandByColors.surfaceDark,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: StandByColors.textPrimary,
                      ),
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: StandByColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

/// Switch row with cyan toggle, no Card wrapper
class SBSwitchRow extends StatelessWidget {
  const SBSwitchRow({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: StandByColors.surfaceDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: StandByColors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: StandByColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: StandByColors.accent,
          ),
        ],
      ),
    );
  }
}

/// 1-tap color picker row: tap the color circle to open picker directly
class SBColorPickerRow extends StatefulWidget {
  const SBColorPickerRow({
    super.key,
    required this.label,
    required this.currentColor,
    required this.onColorChanged,
    this.dialogTitle,
  });

  final String label;
  final Color currentColor;
  final ValueChanged<Color> onColorChanged;
  final String? dialogTitle;

  @override
  State<SBColorPickerRow> createState() => _SBColorPickerRowState();
}

class _SBColorPickerRowState extends State<SBColorPickerRow> {
  double _scale = 1.0;

  Future<void> _openPicker() async {
    final picked = await showColorPickerDialog(
      context,
      widget.currentColor,
      title: Text(
        widget.dialogTitle ?? widget.label,
        style: const TextStyle(fontSize: 18),
      ),
      pickersEnabled: const {
        ColorPickerType.wheel: true,
        ColorPickerType.accent: false,
        ColorPickerType.primary: false,
      },
      enableShadesSelection: true,
      enableTonalPalette: false,
      showColorCode: true,
      colorCodeHasColor: true,
    );
    widget.onColorChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openPicker,
      onTapDown: (_) => setState(() => _scale = 0.9),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: StandByColors.surfaceDark,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            AnimatedScale(
              scale: _scale,
              duration: const Duration(milliseconds: 120),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: widget.currentColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 16,
                  color: StandByColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: StandByColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// Gold PRO badge pill
class SBProBadge extends StatelessWidget {
  const SBProBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: StandByColors.proGoldDim,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'PRO',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: StandByColors.proGold,
        ),
      ),
    );
  }
}

/// Consistent preview container for config screens
class SBPreviewContainer extends StatelessWidget {
  const SBPreviewContainer({
    super.key,
    required this.child,
    this.height = 180,
    this.backgroundColor,
  });

  final Widget child;
  final double height;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? StandByColors.trueBlack,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: StandByColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

/// Info box with title, icon-text list, and optional footnote
class SBInfoBox extends StatelessWidget {
  const SBInfoBox({
    super.key,
    required this.title,
    required this.items,
    this.footnote,
  });

  final String title;
  final List<SBInfoItem> items;
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: StandByColors.surfaceDark,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: StandByColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          for (final item in items) ...[
            Row(
              children: [
                Icon(item.icon, size: 14, color: StandByColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.text,
                    style: const TextStyle(
                      color: StandByColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          if (footnote != null) ...[
            const SizedBox(height: 4),
            Text(
              footnote!,
              style: const TextStyle(
                color: StandByColors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SBInfoItem {
  const SBInfoItem({required this.icon, required this.text});
  final IconData icon;
  final String text;
}
