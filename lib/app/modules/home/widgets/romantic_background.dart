import 'dart:math';

import 'package:flutter/material.dart';

class RomanticBackground extends StatefulWidget {
  final Widget child;
  const RomanticBackground({super.key, required this.child});

  @override
  State<RomanticBackground> createState() => _RomanticBackgroundState();
}

class _RomanticBackgroundState extends State<RomanticBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 10,
      ), // Long duration for continuous drift
    )..repeat();

    // Initialize particles
    for (int i = 0; i < 30; i++) {
      _particles.add(_generateParticle());
    }
  }

  Particle _generateParticle() {
    return Particle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * 20 + 10,
      opacity: _random.nextDouble() * 0.5 + 0.1,
      speed: _random.nextDouble() * 0.05 + 0.02,
      type: _random.nextBool() ? ParticleType.heart : ParticleType.flower,
      color: Colors.pinkAccent.withValues(alpha: 0.5), // Base color
    );
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
        // Romantic Gradient Background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF4A0020), // Deep Burgundy/Pink
                Color(0xFF2E003E), // Deep Purple
                Color(0xFF1A0024), // Dark Violet
              ],
            ),
          ),
        ),
        // Animated Particles
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: ParticlePainter(_particles, _controller.value),
              size: Size.infinite,
            );
          },
        ),
        // Content overlay
        widget.child,
      ],
    );
  }
}

enum ParticleType { heart, flower }

class Particle {
  double x;
  double y;
  double size;
  double opacity;
  double speed;
  ParticleType type;
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
    required this.type,
    required this.color,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      // Movement logic: particles drift up and slightly side-to-side
      double dy = (particle.y - particle.speed * 0.1) % 1.0;
      if (dy < 0) dy += 1.0;
      particle.y = dy;

      double dx =
          particle.x + sin(animationValue * 2 * pi + particle.y * 10) * 0.001;
      particle.x = dx;

      // Draw particle
      paint.color = particle.color.withValues(alpha: particle.opacity);

      final offset = Offset(particle.x * size.width, particle.y * size.height);

      if (particle.type == ParticleType.heart) {
        _drawHeart(canvas, offset, particle.size, paint);
      } else {
        _drawFlower(canvas, offset, particle.size, paint);
      }
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double width, Paint paint) {
    // Simple heart shape path
    Path path = Path();
    path.moveTo(center.dx, center.dy + width / 4);
    path.cubicTo(
      center.dx - width / 2,
      center.dy - width / 2,
      center.dx - width,
      center.dy + width / 3,
      center.dx,
      center.dy + width,
    );
    path.cubicTo(
      center.dx + width,
      center.dy + width / 3,
      center.dx + width / 2,
      center.dy - width / 2,
      center.dx,
      center.dy + width / 4,
    );
    canvas.drawPath(path, paint);
  }

  void _drawFlower(Canvas canvas, Offset center, double size, Paint paint) {
    // Simple flower shape (circle with petals)
    // Draw 5 petals
    double petalSize = size / 2.5;
    for (int i = 0; i < 5; i++) {
      double angle = (i * 2 * pi) / 5;
      double px = center.dx + cos(angle) * (size / 3);
      double py = center.dy + sin(angle) * (size / 3);
      canvas.drawCircle(Offset(px, py), petalSize, paint);
    }
    // Center
    paint.color = Colors.yellow.withValues(alpha: 0.8);
    canvas.drawCircle(center, size / 4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
