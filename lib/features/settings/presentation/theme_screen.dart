// ignore_for_file: curly_braces_in_flow_control_structures, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/theme_provider.dart';
import 'palette_picker_sheet.dart';

/// All 16 custom theme colors.
class _ThemeColor {
  final String name;
  final Color color;
  const _ThemeColor(this.name, this.color);
}

const _customColors = [
  _ThemeColor('Green', Color(0xFF4CAF50)),
  _ThemeColor('Red', Color(0xFFF44336)),
  _ThemeColor('Pink', Color(0xFFE91E63)),
  _ThemeColor('Purple', Color(0xFF9C27B0)),
  _ThemeColor('DeepPurple', Color(0xFF673AB7)),
  _ThemeColor('Indigo', Color(0xFF3F51B5)),
  _ThemeColor('Blue', Color(0xFF2196F3)),
  _ThemeColor('LightBlue', Color(0xFF03A9F4)),
  _ThemeColor('Cyan', Color(0xFF00BCD4)),
  _ThemeColor('Teal', Color(0xFF009688)),
  _ThemeColor('LightGreen', Color(0xFF8BC34A)),
  _ThemeColor('Lime', Color(0xFFCDDC39)),
  _ThemeColor('Yellow', Color(0xFFFFEB3B)),
  _ThemeColor('Amber', Color(0xFFFFC107)),
  _ThemeColor('Orange', Color(0xFFFF9800)),
  _ThemeColor('DeepOrange', Color(0xFFFF5722)),
];

class ThemeScreen extends ConsumerStatefulWidget {
  const ThemeScreen({super.key});
  @override
  ConsumerState<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends ConsumerState<ThemeScreen>
    with TickerProviderStateMixin {
  bool _appearanceExpanded = true;
  bool _extrasExpanded = true;
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final defaultTheme = ref.watch(defaultThemeProvider);
    final materialYou = ref.watch(materialYouProvider);
    final liquidMode = ref.watch(liquidModeProvider);
    final bloom = ref.watch(bloomProvider);
    final oledMode = ref.watch(oledModeProvider);
    final customThemeEnabled = ref.watch(customThemeEnabledProvider);
    final customThemeColor = ref.watch(customThemeColorProvider);
    final accent = ref.watch(accentColorProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color bgColor = theme.cardColor;
    final Color cardColor = theme.cardColor;
    final Color borderColor =
        theme.dividerTheme.color ?? theme.colorScheme.outline;
    final Color textColor = theme.colorScheme.onSurface;
    final Color subtitleColor = theme.colorScheme.onSurface.withOpacity(0.6);
    final Color iconBgColor = isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE5E5EA);
    final Color accentColor = accent;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: kToolbarHeight + 24,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            // ── Rounded back button ──
            GestureDetector(
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/settings');
                }
              },
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3A3A3C)
                      : const Color(0xFFEAEAEA),
                  borderRadius: BorderRadius.circular(10),
                  border: isDark
                      ? null
                      : Border.all(color: const Color(0xFFCCCCCC), width: 1),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: textColor,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Theme',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 8),
          // ══════════════════════════════════════
          // ── APPEARANCE SECTION CARD ──
          // ══════════════════════════════════════
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: borderColor, width: 0.5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              children: [
                _SectionHeader(
                  title: 'Appearance',
                  expanded: _appearanceExpanded,
                  textColor: accentColor,
                  onTap: () => setState(
                    () => _appearanceExpanded = !_appearanceExpanded,
                  ),
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: _appearanceExpanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: _buildAppearanceContent(
                    themeMode: themeMode,
                    defaultTheme: defaultTheme,
                    materialYou: materialYou,
                    liquidMode: liquidMode,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    accentColor: accentColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    iconBgColor: iconBgColor,
                    isDark: isDark,
                  ),
                  secondChild: const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // ══════════════════════════════════════
          // ── EXTRAS SECTION CARD ──
          // ══════════════════════════════════════
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: borderColor, width: 0.5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              children: [
                _SectionHeader(
                  title: 'Extras',
                  expanded: _extrasExpanded,
                  textColor: accentColor,
                  onTap: () =>
                      setState(() => _extrasExpanded = !_extrasExpanded),
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: _extrasExpanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: _buildExtrasContent(
                    themeMode: themeMode,
                    bloom: bloom,
                    oledMode: oledMode,
                    customThemeEnabled: customThemeEnabled,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    accentColor: accentColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    iconBgColor: iconBgColor,
                    isDark: isDark,
                  ),
                  secondChild: const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          // ══════════════════════════════════════
          // ── CUSTOM THEMES GRID ──
          // ══════════════════════════════════════
          AnimatedSize(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: customThemeEnabled
                ? _buildCustomThemesGrid(
                    customThemeColor: customThemeColor,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    accentColor: accentColor,
                    textColor: textColor,
                    isDark: isDark,
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ─────────────────────────────────────
  // APPEARANCE CONTENT
  // ─────────────────────────────────────
  Widget _buildAppearanceContent({
    required ThemeMode themeMode,
    required bool defaultTheme,
    required bool materialYou,
    required bool liquidMode,
    required Color cardColor,
    required Color borderColor,
    required Color accentColor,
    required Color textColor,
    required Color subtitleColor,
    required Color iconBgColor,
    required bool isDark,
  }) {
    return Column(
      children: [
        const SizedBox(height: 12),
        // ── Mode Selector Cards ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: _ModeCard(
                  label: 'Light',
                  isSelected: themeMode == ThemeMode.light,
                  isLight: true,
                  accentColor: accentColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  isDarkApp: isDark,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.light),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ModeCard(
                  label: 'Dark',
                  isSelected: themeMode == ThemeMode.dark,
                  isLight: false,
                  accentColor: accentColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  isDarkApp: isDark,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.dark),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ModeCard(
                  label: 'System',
                  isSelected: themeMode == ThemeMode.system,
                  isLight: false,
                  isSystem: true,
                  accentColor: accentColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  isDarkApp: isDark,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.system),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // ── Toggle Rows ──
        _ToggleRow(
          icon: Icons.brush_rounded,
          iconBgColor: iconBgColor,
          title: 'Default Theme',
          subtitle: 'Play around with App theme',
          value: defaultTheme,
          accentColor: accentColor,
          cardColor: cardColor,
          borderColor: borderColor,
          textColor: textColor,
          subtitleColor: subtitleColor,
          onChanged: (val) {
            ref.read(defaultThemeProvider.notifier).set(val);
            if (val) {
              ref.read(materialYouProvider.notifier).set(false);
              ref.read(customThemeEnabledProvider.notifier).set(false);
              ref
                  .read(customThemeColorProvider.notifier)
                  .setColor(const Color(0xFF3F51B5));
              ref
                  .read(accentColorProvider.notifier)
                  .setColor(const Color(0xFF3F51B5));
            }
          },
        ),
        const SizedBox(height: 5),
        _ToggleRow(
          icon: Icons.auto_awesome_rounded,
          iconBgColor: iconBgColor,
          title: 'Material You',
          subtitle: 'Take color from your wallpaper (A12+)',
          value: materialYou,
          accentColor: accentColor,
          cardColor: cardColor,
          borderColor: borderColor,
          textColor: textColor,
          subtitleColor: subtitleColor,
          onChanged: (val) {
            ref.read(materialYouProvider.notifier).set(val);

            if (val) {
              final raw = ref.read(rawDynamicColorProvider);
              if (raw != null) {
                ref.read(accentColorProvider.notifier).setColor(raw);
                ref.read(defaultThemeProvider.notifier).set(false);
                ref.read(customThemeEnabledProvider.notifier).set(false);
              } else {
                // Android < 12 or iOS — not supported
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Material You requires Android 12+ with a dynamic wallpaper.',
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFF2C2C2E),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                ref.read(materialYouProvider.notifier).set(false);
              }
            } else {
              // Material You turned OFF — restore previous active theme
              final customEnabled = ref.read(customThemeEnabledProvider);
              if (customEnabled) {
                // Custom theme was active: restore its color
                final customColor = ref.read(customThemeColorProvider);
                ref.read(accentColorProvider.notifier).setColor(customColor);
              } else {
                // Nothing else was active: re-enable Default Theme
                ref.read(defaultThemeProvider.notifier).set(true);
                ref
                    .read(accentColorProvider.notifier)
                    .setColor(
                      const Color(0xFF3F51B5),
                    ); // Indigo — same as Default Theme
              }
            }
          },
        ),
        const SizedBox(height: 5),

        _ToggleRow(
          icon: Icons.water_drop_rounded,
          iconBgColor: iconBgColor,
          title: 'Liquid Mode',
          subtitle: 'Make everything glassy & liquidy...',
          value: liquidMode,
          accentColor: accentColor,
          cardColor: cardColor,
          borderColor: borderColor,
          textColor: textColor,
          subtitleColor: subtitleColor,
          onChanged: (_) => ref.read(liquidModeProvider.notifier).toggle(),
        ),
        const SizedBox(height: 5),

        _NavigationRow(
          icon: Icons.add_photo_alternate_outlined,
          iconBgColor: iconBgColor,
          title: 'Liquid Background',
          subtitle: 'Choose a custom background for liquid mode.',
          cardColor: cardColor,
          borderColor: borderColor,
          textColor: textColor,
          subtitleColor: subtitleColor,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Coming soon!',
                  style: GoogleFonts.inter(color: Colors.white),
                ),
                backgroundColor: const Color(0xFF2C2C2E),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }

  // ─────────────────────────────────────
  // EXTRAS CONTENT
  // ─────────────────────────────────────
  Widget _buildExtrasContent({
    required ThemeMode themeMode,
    required bool bloom,
    required bool oledMode,
    required bool customThemeEnabled,
    required Color cardColor,
    required Color borderColor,
    required Color accentColor,
    required Color textColor,
    required Color subtitleColor,
    required Color iconBgColor,
    required bool isDark,
  }) {
    return Column(
      children: [
        const SizedBox(height: 4),
        _ToggleRow(
          icon: Icons.blur_on_rounded,
          iconBgColor: iconBgColor,
          title: 'Bloom',
          subtitle: 'Enables a soft, glowing gradient effect.',
          value: bloom,
          accentColor: accentColor,
          cardColor: cardColor,
          borderColor: borderColor,
          textColor: textColor,
          subtitleColor: subtitleColor,
          onChanged: (_) => ref.read(bloomProvider.notifier).toggle(),
        ),
        const SizedBox(height: 5),

        _NavigationRow(
          icon: Icons.palette_outlined,
          iconBgColor: iconBgColor,
          title: 'Palette',
          subtitle: 'Choose your favourite palette!',
          cardColor: cardColor,
          borderColor: borderColor,
          textColor: textColor,
          subtitleColor: subtitleColor,
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (_) => const PalettePickerSheet(),
            );
          },
        ),
        const SizedBox(height: 5),

        Opacity(
          opacity: (themeMode != ThemeMode.light) ? 1.0 : 0.5,
          child: _ToggleRow(
            icon: Icons.brightness_2_rounded,
            iconBgColor: iconBgColor,
            title: 'Oled Mode',
            subtitle: 'Go Super Dark Mode!',
            value: oledMode && (themeMode != ThemeMode.light),
            accentColor: accentColor,
            cardColor: cardColor,
            borderColor: borderColor,
            textColor: textColor,
            subtitleColor: subtitleColor,
            onChanged: (themeMode != ThemeMode.light)
                ? (val) => ref.read(oledModeProvider.notifier).set(val)
                : null,
          ),
        ),
        const SizedBox(height: 5),

        _ToggleRow(
          icon: Icons.color_lens_outlined,
          iconBgColor: iconBgColor,
          title: 'Custom Theme',
          subtitle: 'Choose your favourite color!',
          value: customThemeEnabled,
          accentColor: accentColor,
          cardColor: cardColor,
          borderColor: borderColor,
          textColor: textColor,
          subtitleColor: subtitleColor,
          onChanged: (val) {
            ref.read(customThemeEnabledProvider.notifier).set(val);
            if (val) {
              ref.read(defaultThemeProvider.notifier).set(false);
              ref.read(materialYouProvider.notifier).set(false);
            }
          },
        ),
      ],
    );
  }

  // ─────────────────────────────────────
  // CUSTOM THEMES GRID
  // ─────────────────────────────────────
  Widget _buildCustomThemesGrid({
    required Color customThemeColor,
    required Color cardColor,
    required Color borderColor,
    required Color accentColor,
    required Color textColor,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Custom Themes',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: _customColors.length,
            itemBuilder: (context, index) {
              final tc = _customColors[index];
              final isSelected = customThemeColor.value == tc.color.value;
              return _ColorThemeCard(
                themeColor: tc,
                isSelected: isSelected,
                isDarkApp: isDark,
                borderColor: borderColor,
                cardColor: cardColor,
                onTap: () {
                  ref
                      .read(customThemeColorProvider.notifier)
                      .setColor(tc.color);
                  // Also update the accent so it takes effect immediately
                  ref.read(accentColorProvider.notifier).setColor(tc.color);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════
// WIDGETS
// ═══════════════════════════════════════
/// Collapsible section header.
class _SectionHeader extends StatelessWidget {
  final String title;
  final bool expanded;
  final Color textColor;
  final VoidCallback onTap;
  const _SectionHeader({
    required this.title,
    required this.expanded,
    required this.textColor,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const Spacer(),
            AnimatedRotation(
              turns: expanded ? 0 : 0.5,
              duration: const Duration(milliseconds: 250),
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: textColor.withOpacity(0.7),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mode selector card (Light / Dark / System) with mini preview.
class _ModeCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isLight;
  final bool isSystem;
  final Color accentColor;
  final Color borderColor;
  final Color textColor;
  final bool isDarkApp;
  final VoidCallback onTap;
  const _ModeCard({
    required this.label,
    required this.isSelected,
    required this.isLight,
    this.isSystem = false,
    required this.accentColor,
    required this.borderColor,
    required this.textColor,
    required this.isDarkApp,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? accentColor.withOpacity(isDarkApp ? 0.8 : 1.0)
                : borderColor,
            width: isSelected ? 2.0 : 1.0,
          ),
          color: isSelected
              ? accentColor.withOpacity(0.08)
              : Colors.transparent,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // Mini preview
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: isLight && !isSystem
                    ? const Color(0xFFF5F5F5)
                    : const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isLight && !isSystem
                      ? const Color(0xFFE0E0E0)
                      : const Color(0xFF333333),
                  width: 0.5,
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: _MiniPreview(
                isLight: isLight && !isSystem,
                isSystem: isSystem,
                accentColor: accentColor,
              ),
            ),
            const SizedBox(height: 6),
            // Checkmark + label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: accentColor,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? textColor : textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Mini phone UI preview inside mode cards.
class _MiniPreview extends StatelessWidget {
  final bool isLight;
  final bool isSystem;
  final Color accentColor;
  const _MiniPreview({
    required this.isLight,
    required this.isSystem,
    required this.accentColor,
  });
  @override
  Widget build(BuildContext context) {
    final fgColor = isLight ? Colors.black87 : Colors.white70;
    final mutedColor = isLight ? Colors.black26 : Colors.white24;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Traffic lights
        Row(
          children: [
            _dot(const Color(0xFFFF5F57), 5),
            const SizedBox(width: 3),
            _dot(const Color(0xFFFFBD2E), 5),
            const SizedBox(width: 3),
            _dot(const Color(0xFF28C840), 5),
            if (isSystem) ...[
              const Spacer(),
              // Half dark indicator
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.grey.shade800],
                    stops: const [0.5, 0.5],
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        // Fake content bars — widths are fractions of available space
        Row(
          children: [
            Expanded(child: _bar(accentColor.withOpacity(0.7), 0.45, 8)),
            const SizedBox(width: 4),
            Expanded(child: _bar(mutedColor, 0.35, 8)),
            const SizedBox(width: 4),
            Expanded(child: _bar(accentColor.withOpacity(0.5), 0.25, 8)),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(child: _bar(fgColor.withOpacity(0.3), 0.55, 7)),
            const SizedBox(width: 4),
            Expanded(child: _bar(accentColor.withOpacity(0.4), 0.30, 7)),
            const SizedBox(width: 4),
            Expanded(child: _bar(mutedColor, 0.40, 7)),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(child: _bar(mutedColor, 0.30, 7)),
            const SizedBox(width: 4),
            Expanded(child: _bar(fgColor.withOpacity(0.2), 0.50, 7)),
          ],
        ),
      ],
    );
  }
}

Widget _dot(Color color, double size) => Container(
  width: size,
  height: size,
  decoration: BoxDecoration(shape: BoxShape.circle, color: color),
);

/// Width-fraction bars so they scale inside any card size.
Widget _bar(Color color, double fraction, double height) =>
    FractionallySizedBox(
      widthFactor: fraction,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );

/// Toggle row with icon badge, title, subtitle, and switch.
class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final bool value;
  final Color accentColor;
  final Color cardColor;
  final Color borderColor;
  final Color textColor;
  final Color subtitleColor;
  final ValueChanged<bool>? onChanged;
  const _ToggleRow({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.accentColor,
    required this.cardColor,
    required this.borderColor,
    required this.textColor,
    required this.subtitleColor,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Row(
          children: [
            // Icon badge
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),

              child: Icon(icon, size: 20, color: textColor.withOpacity(0.8)),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    maxLines: 2,
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            // Switch
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: accentColor,
            ),
          ],
        ),
      ),
    );
  }
}

/// Navigation row with icon badge, title, subtitle, and chevron.
class _NavigationRow extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final Color cardColor;
  final Color borderColor;
  final Color textColor;
  final Color subtitleColor;
  final VoidCallback onTap;
  const _NavigationRow({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.cardColor,
    required this.borderColor,
    required this.textColor,
    required this.subtitleColor,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 0.5),
          ),
          child: Row(
            children: [
              // Icon badge
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: textColor.withOpacity(0.8)),
              ),
              const SizedBox(width: 14),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: subtitleColor, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

/// Color theme card for the custom grid.
class _ColorThemeCard extends StatelessWidget {
  final _ThemeColor themeColor;
  final bool isSelected;
  final bool isDarkApp;
  final Color borderColor;
  final Color cardColor;
  final VoidCallback onTap;
  const _ColorThemeCard({
    required this.themeColor,
    required this.isSelected,
    required this.isDarkApp,
    required this.borderColor,
    required this.cardColor,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final previewBg = isDarkApp
        ? const Color(0xFF0F0F0F)
        : const Color(0xFFF0F0F0);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? themeColor.color : borderColor,
            width: isSelected ? 2.5 : 1.0,
          ),
          color: cardColor,
        ),
        child: Column(
          children: [
            // Mini preview tinted with the color
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: previewBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _tintBar(themeColor.color, 0.45, 8)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: _tintBar(
                            themeColor.color.withOpacity(0.4),
                            0.35,
                            8,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: _tintBar(
                            themeColor.color.withOpacity(0.2),
                            0.25,
                            8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: _tintBar(
                            themeColor.color.withOpacity(0.3),
                            0.40,
                            7,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(child: _tintBar(themeColor.color, 0.30, 7)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _tintBar(themeColor.color.withOpacity(0.15), 0.75, 6),
                  ],
                ),
              ),
            ),
            // Label + check
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected) ...[
                    Icon(
                      Icons.check_circle_rounded,
                      size: 14,
                      color: themeColor.color,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    themeColor.name,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? themeColor.color
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tintBar(Color color, double width, double height) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(3),
    ),
  );
}
