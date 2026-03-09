import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../models/clock_style.dart';
import '../../shared/design_system.dart';
import '../../services/widget_reload_service.dart';

class ClockConfigScreen extends ConsumerWidget {
  const ClockConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isPro = settings.isPro;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock Widgets'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'STIL WÄHLEN',
            style: Theme.of(context).textTheme.labelSmall,
          ),
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
          const SizedBox(height: 24),
          Text(
            'OPTIONEN',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('24-Stunden-Format'),
                  value: settings.use24HourFormat,
                  activeThumbColor: StandByColors.accent,
                  onChanged: (v) async {
                    await ref.read(settingsProvider.notifier).update(
                          (s) => s.copyWith(use24HourFormat: v),
                        );
                    await WidgetReloadService().reloadAllWidgets();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
        ClockStyle.gradientClock => Icons.gradient_rounded,
        ClockStyle.binaryClock => Icons.grid_on_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected
            ? const BorderSide(color: StandByColors.accent, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(_icon, color: StandByColors.accent, size: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      style.displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: StandByColors.textPrimary,
                      ),
                    ),
                    Text(
                      style.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: StandByColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLocked)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: StandByColors.proGold.withValues(alpha: 0.2),
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
                ),
              if (isSelected && !isLocked)
                const Icon(Icons.check_circle, color: StandByColors.accent),
            ],
          ),
        ),
      ),
    );
  }
}
