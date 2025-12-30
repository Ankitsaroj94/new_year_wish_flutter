import 'dart:math';

import 'package:flutter/material.dart';

class StarFieldBackground extends StatefulWidget {
  final Widget child;
  const StarFieldBackground({super.key, required this.child});

  @override
  State<StarFieldBackground> createState() => _StarFieldBackgroundState();
}

class _StarFieldBackgroundState extends State<StarFieldBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    for (int i = 0; i < 100; i++) {
      _stars.add(Star());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Deep Midnight Purple Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2E003E), // Deepest Purple
                Color(0xFF3B0054),
                Color(0xFF120024), // Almost Black
              ],
            ),
          ),
        ),
        // Twinkling Stars
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: StarPainter(_stars, _controller.value),
              size: Size.infinite,
            );
          },
        ),
        // Content
        widget.child,
      ],
    );
  }
}

class Star {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double size = Random().nextDouble() * 2 + 1;
  double opacity = Random().nextDouble();
  double speed = Random().nextDouble() * 0.05 + 0.01;
}

class StarPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  StarPainter(this.stars, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (var star in stars) {
      // Twinkle effect
      double opacity = (star.opacity + animationValue) % 1.0;
      if (opacity > 0.5) opacity = 1.0 - opacity; // Ping pong opacity

      paint.color = Colors.white.withOpacity(opacity.clamp(0.2, 0.8));

      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
