import 'package:flutter/material.dart';
import '../../controller/calculator_controller.dart';

class CalculatorToolbar extends StatelessWidget {
  const CalculatorToolbar({
    super.key,
    required this.controller,
    required this.onShowScientific,
  });

  final CalculatorController controller;
  final VoidCallback onShowScientific;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.more_horiz_rounded),
                color: primary,
                iconSize: 40,
                onPressed: onShowScientific,
              ),
              const SizedBox(width: 50),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_up_rounded),
                color: primary,
                iconSize: 40,
                onPressed: () => controller.onKeyPressed('^'),
              ),
            ],
          ),
          GestureDetector(
            onTap: controller.onBackspace,
            onLongPress: controller.onClear,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.backspace_rounded, color: primary, size: 35),
            ),
          ),
        ],
      ),
    );
  }
}
