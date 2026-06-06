// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/providers/theme_provider.dart';

/// All palette options.
const _paletteOptions = [
  'TonalSpot',
  'Fidelity',
  'Monochrome',
  'Neutral',
  'Vibrant',
  'Expressive',
  'Content',
  'Rainbow',
  'FruitSalad',
];

/// Icon for each palette style.
IconData _paletteIcon(String name) {
  switch (name) {
    case 'TonalSpot':
      return Icons.tonality_rounded;
    case 'Fidelity':
      return Icons.tune_rounded;
    case 'Monochrome':
      return Icons.contrast_rounded;
    case 'Neutral':
      return Icons.balance_rounded;
    case 'Vibrant':
      return Icons.flash_on_rounded;
    case 'Expressive':
      return Icons.auto_awesome_rounded;
    case 'Content':
      return Icons.article_rounded;
    case 'Rainbow':
      return Icons.looks_rounded;
    case 'FruitSalad':
      return Icons.eco_rounded;
    default:
      return Icons.palette_rounded;
  }
}

class PalettePickerSheet extends ConsumerWidget {
  const PalettePickerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPalette = ref.watch(paletteProvider);
    final accent = ref.watch(accentColorProvider);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = theme.cardColor; // Using card color to pop out from background
    final textColor = theme.colorScheme.onSurface;
    final iconColor = isDark ? Colors.white54 : Colors.black54;
    final handleColor = isDark ? Colors.white24 : Colors.black26;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle bar ──
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: handleColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // ── Title ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.palette_rounded, color: accent, size: 22),
                const SizedBox(width: 10),
                Text(
                  'Choose Palette',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ── Palette list ──
          ...List.generate(_paletteOptions.length, (index) {
            final palette = _paletteOptions[index];
            final isSelected = currentPalette == palette;
            return _PaletteRow(
              name: palette,
              icon: _paletteIcon(palette),
              isSelected: isSelected,
              accentColor: accent,
              textColor: textColor,
              iconColor: iconColor,
              isDark: isDark,
              isLast: index == _paletteOptions.length - 1,
              onTap: () {
                ref.read(paletteProvider.notifier).setPalette(palette);
                Navigator.pop(context);
              },
            );
          }),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}

class _PaletteRow extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isSelected;
  final Color accentColor;
  final Color textColor;
  final Color iconColor;
  final bool isDark;
  final bool isLast;
  final VoidCallback onTap;

  const _PaletteRow({
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.accentColor,
    required this.textColor,
    required this.iconColor,
    required this.isDark,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final defaultIconBg = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5EA);
    final borderColor = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5EA);
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(color: borderColor, width: 0.5),
                ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected
                    ? accentColor.withOpacity(0.15)
                    : defaultIconBg,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isSelected ? accentColor : iconColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? textColor : textColor.withOpacity(0.7),
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, size: 20, color: accentColor),
          ],
        ),
      ),
    );
  }
}
