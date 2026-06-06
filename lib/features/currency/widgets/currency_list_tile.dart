// lib/features/currency/widgets/currency_list_tile.dart

import 'package:calc_sphere/features/currency/service/currency_model.dart';
import 'package:flutter/material.dart';
import 'package:calc_sphere/features/currency/widgets/radio_circle.dart';

class CurrencyListTile extends StatelessWidget {
  final CurrencyModel currency;
  final bool isSelected;
  final bool editMode;
  final bool isHidden;
  final Color tealColor;
  final VoidCallback onTap;
  final VoidCallback onToggleHidden;

  const CurrencyListTile({
    super.key,
    required this.currency,
    required this.isSelected,
    required this.editMode,
    required this.isHidden,
    required this.tealColor,
    required this.onTap,
    required this.onToggleHidden,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: editMode ? onToggleHidden : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Flag
            Text(currency.flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),

            // Currency name & code
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currency.code,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF999999),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Right side: radio (normal) or visibility toggle (edit mode)
            if (editMode)
              Icon(
                isHidden
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: isHidden ? Colors.grey : tealColor,
                size: 22,
              )
            else
              RadioCircle(selected: isSelected, color: tealColor),
          ],
        ),
      ),
    );
  }
}
