import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/romantic_background.dart';

class Reveal2026View extends StatefulWidget {
  const Reveal2026View({super.key});

  @override
  State<Reveal2026View> createState() => _Reveal2026ViewState();
}

class _Reveal2026ViewState extends State<Reveal2026View>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_flipController)
      ..addListener(() {
        if (_animation.value > 0.5 && _isFront) {
          setState(() {
            _isFront = false;
          });
        }
      });
  }

  void _flipCard() {
    if (_flipController.isCompleted) return; // Stay open
    _flipController.forward();
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RomanticBackground(
        child: Center(
          child: GestureDetector(
            onTap: _flipCard,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final angle = _animation.value * pi;
                final transform = Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Perspective
                  ..rotateY(angle);

                return Transform(
                  transform: transform,
                  alignment: Alignment.center,
                  child: _isFront
                      ? _buildFront()
                      : Transform(
                          transform: Matrix4.identity()
                            ..rotateY(pi), // Mirror back
                          alignment: Alignment.center,
                          child: _buildBack(),
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFront() {
    return Container(
      width: 320,
      height: 500,
      decoration: BoxDecoration(
        color: Colors.pink[800],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 20)],
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFFFD700), width: 3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Happy\nNew Year\n2026",
                textAlign: TextAlign.center,
                style: GoogleFonts.dancingScript(
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.touch_app, color: Colors.white70),
              Text(
                "Tap to Open",
                style: GoogleFonts.quicksand(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      width: 320,
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 20)],
      ),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: DefaultTextStyle(
          style: GoogleFonts.quicksand(
            fontSize: 18,
            color: Colors.black87,
            height: 1.5,
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                "My Dearest,\n\n"
                "As we step into 2026, I want to thank you for every moment we've shared. "
                "You are my rock, my joy, and my greatest adventure.\n\n"
                "I promise to love you more with each passing day, to stand by you, and to fill our year with endless smiles.\n\n"
                "Here's to us, and to a year as beautiful as you are.\n\n"
                "With all my love,\nMe",
                speed: const Duration(milliseconds: 50),
              ),
            ],
            displayFullTextOnTap: true,
            isRepeatingAnimation: false,
          ),
        ),
      ),
    );
  }
}
