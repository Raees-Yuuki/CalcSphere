// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../shared/models/calculator_info.dart';
import '../../shared/providers/theme_provider.dart';

/// iOS-style grouped card drawer with Favourites and All Calculators sections.
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final favouriteIds = ref.watch(favouritesProvider);
    final themeMode = ref.watch(themeModeProvider);

    final favourites = favouriteIds
        .map((id) => CalculatorInfo.byId(id))
        .whereType<CalculatorInfo>()
        .toList();
    final allCalcs = List<CalculatorInfo>.from(CalculatorInfo.all)
      ..sort((a, b) => a.name.compareTo(b.name));

    return Drawer(
      backgroundColor: isDark
          ? const Color(0xFF1C1C1E)
          : const Color(0xFFF2F2F7),
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '∑',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'CalcSphere',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      ref.read(themeModeProvider.notifier).toggle();
                    },
                    child: GestureDetector(
                      onTap: () {
                        ref.read(themeModeProvider.notifier).toggle();
                      },
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(
                          begin: 0,
                          end: themeMode == ThemeMode.dark ? 1 : 0,
                        ),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        builder: (context, value, child) {
                          return Transform.rotate(
                            angle: value * 3.14,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(0.08)
                                    : Colors.black.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                value > 0.5
                                    ? Icons.light_mode_rounded
                                    : Icons.dark_mode_rounded,
                                color: isDark
                                    ? Colors.amberAccent
                                    : Colors.orange,
                                size: 22,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // ── Favourites Section ──
                  if (favourites.isNotEmpty) ...[
                    _SectionLabel('FAVOURITES'),
                    _GroupedCard(
                      children: favourites
                          .map(
                            (calc) => _CalcRow(
                              calc: calc,
                              isLast: calc == favourites.last,
                              onTap: () {
                                Navigator.pop(context);
                                context.go(calc.route);
                              },
                              onLongPress: () {
                                ref
                                    .read(favouritesProvider.notifier)
                                    .toggle(calc.id);
                              },
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ── All Calculators Section ──
                  _SectionLabel('ALL CALCULATORS'),
                  _GroupedCard(
                    children: allCalcs
                        .map(
                          (calc) => _CalcRow(
                            calc: calc,
                            isLast: calc == allCalcs.last,
                            onTap: () {
                              Navigator.pop(context);
                              context.go(calc.route);
                            },
                            onLongPress: () {
                              ref
                                  .read(favouritesProvider.notifier)
                                  .toggle(calc.id);
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // ── Bottom Section ──
                  _GroupedCard(
                    children: [
                      _SimpleRow(
                        icon: Icons.settings_rounded,
                        label: 'Settings',
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/settings');
                        },
                      ),
                      _SimpleRow(
                        icon: Icons.star_rounded,
                        label: 'Rate App',
                        isLast: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF8E8E93),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _GroupedCard extends StatelessWidget {
  final List<Widget> children;
  const _GroupedCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC6C6C8),
          width: 0.5,
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

class _CalcRow extends StatelessWidget {
  final CalculatorInfo calc;
  final bool isLast;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _CalcRow({
    required this.calc,
    this.isLast = false,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: 44,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: calc.color,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    alignment: Alignment.center,
                    child: Icon(calc.icon, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      calc.name,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: isDark
                        ? const Color(0xFF3A3A3C)
                        : const Color(0xFFC6C6C8),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Divider(
              height: 0.5,
              thickness: 0.5,
              color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC6C6C8),
            ),
          ),
      ],
    );
  }
}

class _SimpleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLast;
  final VoidCallback onTap;

  const _SimpleRow({
    required this.icon,
    required this.label,
    this.isLast = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: 44,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: const Color(0xFF8E8E93)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: isDark
                        ? const Color(0xFF3A3A3C)
                        : const Color(0xFFC6C6C8),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Divider(
              height: 0.5,
              thickness: 0.5,
              color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC6C6C8),
            ),
          ),
      ],
    );
  }
}
