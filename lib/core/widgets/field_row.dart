import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tappable field row for specialty calculators.
/// Shows label on left, value on right, with tap-to-edit support.
class FieldRow extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final VoidCallback? onTap;
  final Color? valueColor;
  final bool isResult;

  const FieldRow({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.onTap,
    this.valueColor,
    this.isResult = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFC6C6C8),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8E8E93),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      value.isEmpty ? 'Tap to enter' : value,
                      style: GoogleFonts.inter(
                        fontSize: isResult ? 20 : 16,
                        fontWeight: isResult
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: value.isEmpty
                            ? const Color(0xFF8E8E93)
                            : (valueColor ??
                                  (isDark ? Colors.white : Colors.black)),
                      ),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (unit != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      unit!,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8E8E93),
                      ),
                    ),
                  ],
                  if (onTap != null && !isResult)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: Color(0xFFC6C6C8),
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
}
