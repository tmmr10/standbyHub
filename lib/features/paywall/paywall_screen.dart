import 'package:flutter/material.dart';
import 'package:standby_hub/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  // Header
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            StandByColors.proGold.withValues(alpha: 0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.star_rounded, size: 52, color: StandByColors.proGold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'StandBy Hub Pro',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: StandByColors.proGold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      l10n.paywallSubtitle,
                      style: const TextStyle(fontSize: 15, color: StandByColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Pro Clock Styles Preview
                  _SectionLabel(l10n.paywallClockStyles),
                  const SizedBox(height: 10),
                  const SizedBox(
                    height: 140,
                    child: Row(
                      children: [
                        Expanded(child: _ProClockCard(type: _ProClock.flipClock)),
                        SizedBox(width: 10),
                        Expanded(child: _ProClockCard(type: _ProClock.binaryClock)),
                        SizedBox(width: 10),
                        Expanded(child: _ProClockCard(type: _ProClock.pixelArt)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pro Ambient Backgrounds Preview
                  _SectionLabel(l10n.paywallBackgrounds),
                  const SizedBox(height: 10),
                  const SizedBox(
                    height: 80,
                    child: Row(
                      children: [
                        Expanded(child: _AmbientCard(name: 'Sunset', colors: [Color(0xFFFF6F00), Color(0xFFE91E63), Color(0xFF4A148C)])),
                        SizedBox(width: 8),
                        Expanded(child: _AmbientCard(name: 'Forest', colors: [Color(0xFF1B5E20), Color(0xFF00695C), Color(0xFF004D40)])),
                        SizedBox(width: 8),
                        Expanded(child: _AmbientCard(name: 'Nebula', colors: [Color(0xFFAA00FF), Color(0xFFE040FB), Color(0xFF880E4F)])),
                        SizedBox(width: 8),
                        Expanded(child: _AmbientCard(name: 'Custom', colors: [Color(0xFF1A237E), Color(0xFF283593), Color(0xFF1A237E)])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Feature list
                  _SectionLabel(l10n.paywallAllFeatures),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: StandByColors.surfaceDark,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        _FeatureRow(icon: Icons.access_time_rounded, text: l10n.paywallFeatureClocks),
                        const Divider(color: StandByColors.divider, height: 1),
                        _FeatureRow(icon: Icons.gradient_rounded, text: l10n.paywallFeatureAmbients),
                        const Divider(color: StandByColors.divider, height: 1),
                        _FeatureRow(icon: Icons.palette_rounded, text: l10n.paywallFeatureColors),
                        const Divider(color: StandByColors.divider, height: 1),
                        _FeatureRow(icon: Icons.dashboard_rounded, text: l10n.paywallFeatureSlots),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),

            // Buy / Restore section (fixed at bottom)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isPro)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        color: StandByColors.proGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, color: StandByColors.proGold),
                          const SizedBox(width: 8),
                          Text(
                            l10n.paywallProActive,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: StandByColors.proGold),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: StandByColors.proGold.withValues(alpha: 0.25),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: SizedBox(
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
                          child: Text(
                            l10n.paywallBuyButton,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () async {
                        final service = ref.read(purchaseServiceProvider);
                        await service.restorePurchases();
                      },
                      child: Text(
                        l10n.paywallRestore,
                        style: const TextStyle(color: StandByColors.textSecondary),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: StandByColors.proGold,
        letterSpacing: 0.5,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

enum _ProClock { flipClock, binaryClock, pixelArt }

class _ProClockCard extends StatelessWidget {
  const _ProClockCard({required this.type});
  final _ProClock type;

  String get _label => switch (type) {
        _ProClock.flipClock => 'Flip Clock',
        _ProClock.binaryClock => 'Binary',
        _ProClock.pixelArt => 'Pixel Art',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: StandByColors.trueBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: StandByColors.surfaceCard, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: switch (type) {
                  _ProClock.flipClock => const _TinyFlipClock(),
                  _ProClock.binaryClock => const _TinyBinaryClock(),
                  _ProClock.pixelArt => const _TinyPixelArt(),
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              color: StandByColors.surfaceDark,
              child: Text(
                _label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: StandByColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tiny Clock Previews for Paywall
// ─────────────────────────────────────────────────────────────────────────────

class _TinyFlipClock extends StatelessWidget {
  const _TinyFlipClock();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _TinyFlipDigit(h[0]), _TinyFlipDigit(h[1]),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Text(':', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: StandByColors.proGold)),
      ),
      _TinyFlipDigit(m[0]), _TinyFlipDigit(m[1]),
    ]);
  }
}

class _TinyFlipDigit extends StatelessWidget {
  const _TinyFlipDigit(this.digit);
  final String digit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20, height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
      ),
      child: Stack(children: [
        Positioned(left: 0, right: 0, top: 13, child: Container(height: 1, color: const Color(0xFF000000))),
        Center(child: Text(digit, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: StandByColors.proGold, height: 1))),
      ]),
    );
  }
}

class _TinyBinaryClock extends StatelessWidget {
  const _TinyBinaryClock();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final digits = [now.hour ~/ 10, now.hour % 10, now.minute ~/ 10, now.minute % 10];
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      for (var i = 0; i < digits.length; i++) ...[
        if (i == 2) const SizedBox(width: 6),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (var bit = 3; bit >= 0; bit--)
            Container(width: 8, height: 8, margin: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: (digits[i] >> bit) & 1 == 1
                    ? StandByColors.proGold
                    : StandByColors.proGold.withValues(alpha: 0.12))),
        ]),
        const SizedBox(width: 3),
      ],
    ]);
  }
}

class _TinyPixelArt extends StatelessWidget {
  const _TinyPixelArt();

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final Color sky;
    final Color ground;
    final String icon;
    if (hour >= 6 && hour < 10) {
      sky = const Color(0xFFFF9A56); ground = const Color(0xFF3A7D0A); icon = '🌅';
    } else if (hour >= 10 && hour < 17) {
      sky = const Color(0xFF4FC3F7); ground = const Color(0xFF4CAF50); icon = '☀️';
    } else if (hour >= 17 && hour < 20) {
      sky = const Color(0xFF2D1B4E); ground = const Color(0xFF16213E); icon = '🌇';
    } else {
      sky = const Color(0xFF0D1B2A); ground = const Color(0xFF1B2838); icon = '🌙';
    }

    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        width: 70, height: 36,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Stack(children: [
            Column(children: [
              Expanded(flex: 3, child: Container(color: sky)),
              Expanded(flex: 2, child: Container(color: ground)),
            ]),
            Positioned(left: 3, top: 2, child: Text(icon, style: const TextStyle(fontSize: 10))),
          ]),
        ),
      ),
      const SizedBox(height: 4),
      Text(timeStr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: StandByColors.proGold)),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _AmbientCard extends StatelessWidget {
  const _AmbientCard({required this.name, required this.colors});
  final String name;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (name == 'Custom')
              const Icon(Icons.colorize_rounded, color: Colors.white70, size: 20)
            else
              const SizedBox.shrink(),
            const SizedBox(height: 2),
            Text(
              name,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: StandByColors.proGold, size: 22),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 15, color: StandByColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
