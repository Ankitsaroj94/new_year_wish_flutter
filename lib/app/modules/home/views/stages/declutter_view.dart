import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/home_controller.dart';
import '../../widgets/romantic_background.dart';

class DeclutterView extends GetView<HomeController> {
  const DeclutterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RomanticBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
                "Swipe away the bad vibes...",
                style: GoogleFonts.dancingScript(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn(),
              Expanded(
                child: Center(
                  child: Obx(() {
                    if (controller.declutterItems.isEmpty) {
                      // Gift Reveal
                      return GestureDetector(
                        onTap: controller.openGift,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                                  Icons.card_giftcard,
                                  size: 120,
                                  color: Colors.amber,
                                )
                                .animate()
                                .fadeIn()
                                .scale(
                                  duration: 500.ms,
                                  curve: Curves.elasticOut,
                                )
                                .then()
                                .shake(),
                            const SizedBox(height: 20),
                            Text(
                              "Tap for a surprise!",
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ).animate().fadeIn(),
                          ],
                        ),
                      );
                    }

                    // Card Stack
                    return Stack(
                      alignment: Alignment.center,
                      children: controller.declutterItems.reversed.map((item) {
                        return Draggable<String>(
                          data: item,
                          feedback: _buildCard(item, isDragging: true),
                          childWhenDragging: Container(),
                          onDragEnd: (details) {
                            // Check if dragged far enough
                            if (details.offset.distance > 100) {
                              controller.removeDeclutterItem(item);
                            }
                          },
                          child: _buildCard(item),
                        );
                      }).toList(),
                    );
                  }),
                ),
              ),
              // Drag Target Zone (Visual cue mainly)
              Container(
                height: 100,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black45],
                  ),
                ),
                child: Text(
                  "Flick them away!",
                  style: GoogleFonts.quicksand(color: Colors.white54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String text, {bool isDragging = false}) {
    Color cardColor;
    switch (text) {
      case 'Work':
        cardColor = const Color(0xFFFFCC80); // Softer Orange
        break;
      case 'Stress':
        cardColor = const Color(0xFFFFF59D); // Softer Yellow
        break;
      case 'Bad Days':
        cardColor = const Color(0xFFEF9A9A); // Softer Red
        break;
      case 'Distance':
        cardColor = const Color(0xFF90CAF9); // Softer Blue
        break;
      default:
        cardColor = Colors.white;
    }

    // Random slight rotation for "messy" natural look
    // We can use the string length to generate a pseudo-random angle so it's consistent for the same card
    final double angle = (text.length % 5 - 2) * 0.05;

    return Transform.rotate(
      angle: isDragging ? 0 : angle,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: Get.width * 0.85, // Much larger width
          height: 400,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(60), // Folded/Organic corner effect
            ),
            boxShadow: [
              if (!isDragging)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(5, 10),
                ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: GoogleFonts.permanentMarker(
                  // Handwriting style
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Tap to discard",
                style: GoogleFonts.caveat(fontSize: 24, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
