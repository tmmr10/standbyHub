import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../models/dashboard_slot.dart';
import '../../shared/design_system.dart';
import '../../services/widget_reload_service.dart';

class DashboardConfigScreen extends ConsumerWidget {
  const DashboardConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final slots = settings.dashboardSlots;

    return Scaffold(
      appBar: AppBar(title: const Text('Smart Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'DASHBOARD SLOTS',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 12),
          ...DashboardSlotType.values.map((type) {
            final slot = slots.where((s) => s.type == type).firstOrNull;
            final isEnabled = slot?.enabled ?? true;

            return Card(
              child: SwitchListTile(
                title: Text(
                  type.displayName,
                  style: const TextStyle(color: StandByColors.textPrimary),
                ),
                secondary: Icon(
                  _iconForSlot(type),
                  color: StandByColors.accent,
                ),
                activeThumbColor: StandByColors.accent,
                value: isEnabled,
                onChanged: (v) async {
                  final updatedSlots = DashboardSlotType.values.map((t) {
                    final existing =
                        slots.where((s) => s.type == t).firstOrNull;
                    if (t == type) {
                      return (existing ?? DashboardSlot(type: t))
                          .copyWith(enabled: v);
                    }
                    return existing ?? DashboardSlot(type: t);
                  }).toList();

                  await ref.read(settingsProvider.notifier).update(
                        (s) => s.copyWith(dashboardSlots: updatedSlots),
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
            child: SwitchListTile(
              title: const Text(
                'Tageszeit-Reaktivität',
                style: TextStyle(color: StandByColors.textPrimary),
              ),
              subtitle: Text(
                'Farben passen sich an die Tageszeit an',
                style: TextStyle(
                  color: settings.isPro
                      ? StandByColors.textSecondary
                      : StandByColors.textMuted,
                  fontSize: 12,
                ),
              ),
              secondary: const Icon(
                Icons.brightness_6_rounded,
                color: StandByColors.accent,
              ),
              activeThumbColor: StandByColors.accent,
              value: settings.timeOfDayReactivity,
              onChanged: settings.isPro
                  ? (v) async {
                      await ref.read(settingsProvider.notifier).update(
                            (s) => s.copyWith(timeOfDayReactivity: v),
                          );
                      await WidgetReloadService().reloadAllWidgets();
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForSlot(DashboardSlotType type) => switch (type) {
        DashboardSlotType.calendar => Icons.calendar_today_rounded,
        DashboardSlotType.weather => Icons.cloud_rounded,
        DashboardSlotType.battery => Icons.battery_full_rounded,
      };
}
