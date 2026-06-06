// lib/features/currency/widgets/currency_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrencyCard extends StatelessWidget {
  final String cur;
  final String flag;
  final String amt;
  final bool isDark;
  final bool active;
  final VoidCallback onPick;

  const CurrencyCard({
    super.key,
    required this.cur,
    required this.flag,
    required this.amt,
    required this.isDark,
    required this.active,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active
              ? Theme.of(context).colorScheme.primary
              : (isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC6C6C8)),
          width: active ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPick,
            child: Row(
              children: [
                Text(flag, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 8),
                Text(
                  cur,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Color(0xFF8E8E93),
                ),
              ],
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              amt,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
