import 'package:flutter/material.dart';

/// Animated swap button with 180° rotation.
class SwapButton extends StatefulWidget {
  final VoidCallback onSwap;

  const SwapButton({super.key, required this.onSwap});

  @override
  State<SwapButton> createState() => _SwapButtonState();
}

class _SwapButtonState extends State<SwapButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _turns = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() => _turns += 0.5);
    widget.onSwap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedRotation(
        turns: _turns,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutBack,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.swap_vert_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}
