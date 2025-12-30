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

    // Initialize particles (Reduced count for performance)
    for (int i = 0; i < 10; i++) {
      _particles.add(_generateParticle());
    }
  }

  Particle _generateParticle() {
    return Particle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * 15 + 5, // Smaller range
      opacity: _random.nextDouble() * 0.4 + 0.1,
      speed: _random.nextDouble() * 0.03 + 0.01, // Slower
      type: _random.nextBool() ? ParticleType.heart : ParticleType.flower,
      color: Colors.pinkAccent.withValues(alpha: 0.5),
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
        // Romantic Gradient Background (Static Container)
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF4A0020), Color(0xFF2E003E), Color(0xFF1A0024)],
            ),
          ),
        ),
        // Animated Particles
        RepaintBoundary(
          // distinct layer
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(_particles, _controller.value),
                size: Size.infinite,
              );
            },
          ),
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
      // Movement logic
      double dy = (particle.y - particle.speed * 0.1) % 1.0;
      if (dy < 0) dy += 1.0;
      particle.y = dy;

      double dx =
          particle.x + sin(animationValue * 2 * pi + particle.y * 10) * 0.001;
      particle.x = dx;

      // Draw particle as simple Circle for performance optimization
      // (User requested aggressive reduction)
      paint.color = particle.color.withValues(alpha: particle.opacity);
      final offset = Offset(particle.x * size.width, particle.y * size.height);

      // Draw simple circle instead of complex path
      canvas.drawCircle(offset, particle.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
