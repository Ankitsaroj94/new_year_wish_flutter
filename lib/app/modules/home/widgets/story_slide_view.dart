import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:magic_image/magic_image.dart';

class StorySlideView extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final TextStyle scriptStyle;
  final TextStyle bodyStyle;
  final bool isLastSlide;

  const StorySlideView({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.scriptStyle,
    required this.bodyStyle,
    this.isLastSlide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Layer 1: Blurred Background Image
        Positioned.fill(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ).animate().fadeIn(duration: 800.ms),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(
                0.3,
              ), // Darken background for contrast
            ),
          ),
        ),

        // Layer 2: Content
        Center(
          child: Container(
            width: Get.width > 600 ? 500 : Get.width * 0.9,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // Glass effect
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Clear Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: Get.height * 0.5),
                    child: MagicImage(imagePath, fit: BoxFit.contain),
                  ),
                ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

                const SizedBox(height: 32),

                // Title
                Text(
                  title,
                  style: scriptStyle.copyWith(
                    color: Colors.white,
                    fontSize: 42,
                  ),
                  textAlign: TextAlign.center,
                ).animate().slideY(begin: 0.3, end: 0, delay: 200.ms).fadeIn(),

                const SizedBox(height: 16),

                // Subtitle
                Text(
                  subtitle,
                  style: bodyStyle.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ).animate().slideY(begin: 0.3, end: 0, delay: 400.ms).fadeIn(),

                if (isLastSlide) ...[
                  const SizedBox(height: 32),
                  Icon(Icons.favorite, color: Colors.pinkAccent, size: 48)
                      .animate(onPlay: (controller) => controller.repeat())
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.2, 1.2),
                        duration: 1000.ms,
                      )
                      .then()
                      .scale(
                        begin: const Offset(1.2, 1.2),
                        end: const Offset(1, 1),
                        duration: 1000.ms,
                      ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
