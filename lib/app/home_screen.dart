import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:standby_hub/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../shared/design_system.dart';
import '../shared/ui_components.dart';
import '../services/widget_reload_service.dart';
import 'providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = ref.watch(isProProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: StandBySpacing.screenPadding,
          children: [
            const SizedBox(height: 20),
            Text(
              'StandBy Hub',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.appSubtitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 28),

            // Section: Widgets
            SBSectionHeader(l10n.sectionWidgets),
            const SizedBox(height: 12),

            _CategoryCard(
              icon: Icons.access_time_rounded,
              title: l10n.widgetClock,
              subtitle: l10n.widgetClockSubtitle,
              onTap: () => context.push('/clocks'),
            ),
            const SizedBox(height: 10),
            _CategoryCard(
              icon: Icons.calendar_today_rounded,
              title: l10n.widgetCalendar,
              subtitle: l10n.widgetCalendarSubtitle,
              onTap: () => context.push('/calendar'),
            ),
            const SizedBox(height: 10),
            _CategoryCard(
              icon: Icons.cloud_rounded,
              title: l10n.widgetWeather,
              subtitle: l10n.widgetWeatherSubtitle,
              onTap: () => context.push('/weather'),
            ),
            const SizedBox(height: 10),
            _CategoryCard(
              icon: Icons.battery_full_rounded,
              title: l10n.widgetBattery,
              subtitle: l10n.widgetBatterySubtitle,
              onTap: () => context.push('/battery'),
            ),

            const SizedBox(height: 10),
            _CategoryCard(
              icon: Icons.nightlight_round,
              title: l10n.widgetMoonPhase,
              subtitle: l10n.widgetMoonPhaseSubtitle,
              onTap: () => context.push('/moon-phase'),
            ),
            const SizedBox(height: 10),
            _CategoryCard(
              icon: Icons.image_rounded,
              title: l10n.widgetPhoto,
              subtitle: l10n.widgetPhotoSubtitle,
              onTap: () => context.push('/photo'),
            ),

            const SizedBox(height: 28),

            // Section: Dashboard
            SBSectionHeader(l10n.sectionDashboard),
            const SizedBox(height: 12),

            _CategoryCard(
              icon: Icons.dashboard_customize_rounded,
              title: l10n.dashboardBuilder,
              subtitle: l10n.dashboardBuilderSubtitle,
              onTap: () => context.push('/dashboard'),
              highlighted: true,
            ),

            const SizedBox(height: 28),

            // Section: Preview
            SBSectionHeader(l10n.sectionPreview),
            const SizedBox(height: 12),

            _CategoryCard(
              icon: Icons.phone_iphone_rounded,
              title: l10n.widgetPreview,
              subtitle: l10n.widgetPreviewSubtitle,
              onTap: () => context.push('/preview'),
            ),

            const SizedBox(height: 28),

            const _SetupGuide(),

            const SizedBox(height: 28),

            if (kDebugMode)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () async {
                      await ref.read(settingsProvider.notifier).update(
                            (s) => s.copyWith(isPro: !s.isPro),
                          );
                      await WidgetReloadService().reloadAllWidgets();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: StandByColors.surfaceDark,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isPro
                                ? Icons.bug_report
                                : Icons.bug_report_outlined,
                            size: 18,
                            color: StandByColors.textMuted,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isPro
                                ? l10n.debugDisablePro
                                : l10n.debugEnablePro,
                            style: const TextStyle(
                              color: StandByColors.textMuted,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (!isPro)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: StandByColors.proGold.withValues(alpha: 0.25),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: FilledButton.icon(
                  onPressed: () => context.push('/pro'),
                  icon: const Icon(Icons.star_rounded),
                  label: Text(l10n.unlockPro),
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
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: 'StandBy Hub',
                  applicationVersion: '1.0.0',
                ),
                child: Text(
                  l10n.licenses,
                  style: const TextStyle(fontSize: 13, color: StandByColors.textMuted),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: StandByColors.surfaceDark,
            borderRadius: BorderRadius.circular(14),
            gradient: widget.highlighted
                ? LinearGradient(
                    colors: [
                      StandByColors.accent.withValues(alpha: 0.05),
                      StandByColors.surfaceDark,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: StandByColors.accentDim,
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon,
                    color: StandByColors.accent, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: StandByColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: StandByColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SetupGuide extends StatefulWidget {
  const _SetupGuide();

  @override
  State<_SetupGuide> createState() => _SetupGuideState();
}

class _SetupGuideState extends State<_SetupGuide> {
  bool _expanded = false;
  int _selectedTab = 0; // 0 = StandBy, 1 = Home Screen

  static List<_GuideStep> _standbySteps(AppLocalizations l10n) => [
    _GuideStep(
      number: '1',
      icon: Icons.bolt_rounded,
      title: l10n.guideStandby1Title,
      detail: l10n.guideStandby1Detail,
    ),
    _GuideStep(
      number: '2',
      icon: Icons.lock_clock_rounded,
      title: l10n.guideStandby2Title,
      detail: l10n.guideStandby2Detail,
    ),
    _GuideStep(
      number: '3',
      icon: Icons.touch_app_rounded,
      title: l10n.guideStandby3Title,
      detail: l10n.guideStandby3Detail,
    ),
    _GuideStep(
      number: '4',
      icon: Icons.search_rounded,
      title: l10n.guideStandby4Title,
      detail: l10n.guideStandby4Detail,
    ),
    _GuideStep(
      number: '5',
      icon: Icons.check_circle_outline_rounded,
      title: l10n.guideStandby5Title,
      detail: l10n.guideStandby5Detail,
    ),
  ];

  static List<_GuideStep> _homeScreenSteps(AppLocalizations l10n) => [
    _GuideStep(
      number: '1',
      icon: Icons.touch_app_rounded,
      title: l10n.guideHome1Title,
      detail: l10n.guideHome1Detail,
    ),
    _GuideStep(
      number: '2',
      icon: Icons.add_circle_outline_rounded,
      title: l10n.guideHome2Title,
      detail: l10n.guideHome2Detail,
    ),
    _GuideStep(
      number: '3',
      icon: Icons.search_rounded,
      title: l10n.guideHome3Title,
      detail: l10n.guideHome3Detail,
    ),
    _GuideStep(
      number: '4',
      icon: Icons.check_circle_outline_rounded,
      title: l10n.guideHome4Title,
      detail: l10n.guideHome4Detail,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = _selectedTab == 0 ? _standbySteps(l10n) : _homeScreenSteps(l10n);

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: StandByColors.surfaceDark,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: StandByColors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.help_outline_rounded,
                    color: StandByColors.accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.guideTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: StandByColors.textPrimary,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: StandByColors.textMuted,
                    size: 22,
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    // Tab Toggle
                    Container(
                      decoration: BoxDecoration(
                        color: StandByColors.trueBlack,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        children: [
                          _GuideTab(
                            label: l10n.guideTabStandby,
                            icon: Icons.lock_clock_rounded,
                            selected: _selectedTab == 0,
                            onTap: () => setState(() => _selectedTab = 0),
                          ),
                          const SizedBox(width: 4),
                          _GuideTab(
                            label: l10n.guideTabHomeScreen,
                            icon: Icons.phone_iphone_rounded,
                            selected: _selectedTab == 1,
                            onTap: () => setState(() => _selectedTab = 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Steps
                    for (var i = 0; i < steps.length; i++) ...[
                      if (i > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 17),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 1.5,
                              height: 12,
                              color: StandByColors.accent.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      _StepRow(step: steps[i]),
                    ],
                  ],
                ),
              ),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideTab extends StatelessWidget {
  const _GuideTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? StandByColors.accent.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: selected ? StandByColors.accent : StandByColors.textMuted),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? StandByColors.accent : StandByColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuideStep {
  const _GuideStep({
    required this.number,
    required this.icon,
    required this.title,
    required this.detail,
  });
  final String number;
  final IconData icon;
  final String title;
  final String detail;
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});
  final _GuideStep step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: StandByColors.accent.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step.number,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: StandByColors.accent,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(step.icon, size: 16, color: StandByColors.accent),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      step.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: StandByColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                step.detail,
                style: const TextStyle(
                  fontSize: 12,
                  color: StandByColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
