import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../shared/design_system.dart';
import 'providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = ref.watch(isProProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'StandBy Hub',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Wähle und konfiguriere deine Widgets',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              _CategoryCard(
                icon: Icons.access_time_rounded,
                title: 'Clock Widgets',
                subtitle: '5 einzigartige Uhren-Stile',
                onTap: () => context.push('/clocks'),
              ),
              const SizedBox(height: 12),
              _CategoryCard(
                icon: Icons.gradient_rounded,
                title: 'Ambient Modes',
                subtitle: 'Stimmungsvolle Farbverläufe',
                onTap: () => context.push('/ambient'),
              ),
              const SizedBox(height: 12),
              _CategoryCard(
                icon: Icons.dashboard_rounded,
                title: 'Smart Dashboard',
                subtitle: 'Kalender, Wetter & Batterie',
                onTap: () => context.push('/dashboard'),
              ),
              const SizedBox(height: 12),
              _CategoryCard(
                icon: Icons.phone_iphone_rounded,
                title: 'StandBy Preview',
                subtitle: 'Sieh wie dein Widget aussieht',
                onTap: () => context.push('/preview'),
              ),
              const Spacer(),
              if (!isPro)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => context.push('/pro'),
                    icon: const Icon(Icons.star_rounded),
                    label: const Text('Pro freischalten'),
                    style: FilledButton.styleFrom(
                      backgroundColor: StandByColors.proGold,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: StandByColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: StandByColors.accent),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: StandByColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: StandByColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: StandByColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
