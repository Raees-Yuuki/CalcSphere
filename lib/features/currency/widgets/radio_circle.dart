// lib/features/currency/widgets/radio_circle.dart

import 'package:flutter/material.dart';

class RadioCircle extends StatelessWidget {
  final bool selected;
  final Color color;

  const RadioCircle({super.key, required this.selected, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? color : const Color(0xFF9E9E9E),
          width: selected ? 2 : 1.5,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
            )
          : null,
    );
  }
}
