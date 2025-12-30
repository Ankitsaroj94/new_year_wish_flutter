import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      width: Get.width - 200,
      height: Get.height - 200,
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
                "My Dearest Love 💖,\n\n"
                "Six years. 💑 We've spent six incredible years walking this path together. 👣 "
                "We have fought, we have struggled, and we have faced storms that would have broken others. ⛈️ "
                "But through it all, we are still here—hand in hand, stronger than ever. 💪❤️\n\n"
                "You are the quiet peace in my chaos 🕊️ and the brightest light in my darkest days. ✨ "
                "I promise to cherish you in the quiet moments and the grand adventures 🌍, to listen, to understand, and to love you more fiercely with every sunrise. 🌅\n\n"
                "Here's to the years behind us, and to the endless years still to come. 🥂✨\n\n"
                "Forever Yours, 💍\nMe",
                speed: const Duration(milliseconds: 30),
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
