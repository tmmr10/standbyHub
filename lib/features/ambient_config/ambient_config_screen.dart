import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../models/ambient_mode.dart';
import '../../shared/design_system.dart';
import '../../services/widget_reload_service.dart';

class AmbientConfigScreen extends ConsumerWidget {
  const AmbientConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isPro = settings.isPro;

    return Scaffold(
      appBar: AppBar(title: const Text('Ambient Modes')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'MODUS WÄHLEN',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 12),
          ...AmbientMode.values.map((mode) {
            final isSelected = settings.selectedAmbient == mode;
            final isLocked = mode.isPro && !isPro;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AmbientModeTile(
                mode: mode,
                isSelected: isSelected,
                isLocked: isLocked,
                onTap: () async {
                  if (isLocked) {
                    context.push('/pro');
                    return;
                  }
                  await ref.read(settingsProvider.notifier).update(
                        (s) => s.copyWith(selectedAmbient: mode),
                      );
                  await WidgetReloadService().reloadAllWidgets();
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AmbientModeTile extends StatelessWidget {
  const _AmbientModeTile({
    required this.mode,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
  });

  final AmbientMode mode;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback onTap;

  List<Color> get _previewColors => switch (mode) {
        AmbientMode.aurora => [
            const Color(0xFF00E676),
            const Color(0xFF00B0FF),
            const Color(0xFF7C4DFF),
          ],
        AmbientMode.lava => [
            const Color(0xFFFF6D00),
            const Color(0xFFFF1744),
            const Color(0xFFD50000),
          ],
        AmbientMode.ocean => [
            const Color(0xFF00B8D4),
            const Color(0xFF0091EA),
            const Color(0xFF1A237E),
          ],
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected
            ? const BorderSide(color: StandByColors.accent, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _previewColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: isLocked
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'PRO',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: StandByColors.proGold,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mode.displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: StandByColors.textPrimary,
                          ),
                        ),
                        Text(
                          mode.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: StandByColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected && !isLocked)
                    const Icon(Icons.check_circle, color: StandByColors.accent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
