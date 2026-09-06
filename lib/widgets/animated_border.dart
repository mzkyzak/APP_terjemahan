import 'package:flutter/material.dart';

class AnimatedBorderContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double borderWidth;
  final List<Color> colors;
  final Duration duration;
  final bool isActive;

  const AnimatedBorderContainer({
    super.key,
    required this.child,
    this.borderRadius = 28,
    this.borderWidth = 1.6,
    this.colors = const [
      Color(0xFF2563EB),
      Color(0xFFEF4444),
      Color(0xFF38BDF8),
    ],
    this.duration = const Duration(milliseconds: 300),
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.18),
            blurRadius: 16,
            spreadRadius: -2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(borderWidth),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(borderRadius - borderWidth),
        ),
        child: child,
      ),
    );
  }
}

