import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../shared/design_system.dart';
import '../../services/purchase_service.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = ref.watch(isProProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
              const Spacer(flex: 1),
              const Icon(
                Icons.star_rounded,
                size: 64,
                color: StandByColors.proGold,
              ),
              const SizedBox(height: 16),
              Text(
                'StandBy Hub Pro',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: StandByColors.proGold,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Einmalkauf — kein Abo',
                style: TextStyle(
                  fontSize: 15,
                  color: StandByColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              const _FeatureRow(
                icon: Icons.access_time_rounded,
                text: 'Alle 5 Uhren-Stile',
              ),
              const _FeatureRow(
                icon: Icons.gradient_rounded,
                text: 'Alle 3 Ambient Modes',
              ),
              const _FeatureRow(
                icon: Icons.palette_rounded,
                text: 'Custom Akzentfarben & Themes',
              ),
              const _FeatureRow(
                icon: Icons.dashboard_rounded,
                text: 'Alle Dashboard-Slots',
              ),
              const _FeatureRow(
                icon: Icons.brightness_6_rounded,
                text: 'Automatische Tageszeit-Farben',
              ),
              const Spacer(flex: 2),
              if (isPro)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: StandByColors.proGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: StandByColors.proGold),
                      SizedBox(width: 8),
                      Text(
                        'Pro ist aktiv',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: StandByColors.proGold,
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      final service = ref.read(purchaseServiceProvider);
                      await service.buyPro();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: StandByColors.proGold,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      '9,99 € — Einmalig freischalten',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () async {
                    final service = ref.read(purchaseServiceProvider);
                    await service.restorePurchases();
                  },
                  child: const Text(
                    'Käufe wiederherstellen',
                    style: TextStyle(color: StandByColors.textMuted),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: StandByColors.proGold, size: 22),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: StandByColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
