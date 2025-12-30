import 'package:flutter/material.dart';
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
              ),
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
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Tap for a surprise!",
                              style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Card Stack
                    return Stack(
                      alignment: Alignment.center,
                      children: controller.declutterItems.reversed
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            final isTop =
                                index == controller.declutterItems.length - 1;

                            if (isTop) {
                              // Interactive Top Card with Dismissible
                              return Dismissible(
                                key: ValueKey(item),
                                direction: DismissDirection.horizontal,
                                onDismissed: (_) {
                                  controller.removeDeclutterItem(item);
                                },
                                child: GestureDetector(
                                  onTap: () =>
                                      controller.removeDeclutterItem(item),
                                  child: _buildCard(item),
                                ),
                              );
                            } else {
                              // Static Background Cards
                              return _buildCard(item);
                            }
                          })
                          .toList(),
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
    String emoji;

    switch (text) {
      case 'Work':
        cardColor = const Color(
          0xFFFF80AB,
        ).withValues(alpha: 0.9); // Pink Accent
        emoji = "💼";
        break;
      case 'Stress':
        cardColor = const Color(0xFFF48FB1).withValues(alpha: 0.9); // Pink 200
        emoji = "😫";
        break;
      case 'Bad Days':
        cardColor = const Color(
          0xFFCE93D8,
        ).withValues(alpha: 0.9); // Purple 200 (Pinkish)
        emoji = "🌧️";
        break;
      case 'Distance':
        cardColor = const Color(
          0xFFFFAB91,
        ).withValues(alpha: 0.9); // Deep Orange 200 (Salmon Pink)
        emoji = "📍";
        break;
      default:
        cardColor = Colors.pink.withValues(alpha: 0.9);
        emoji = "✨";
    }

    // Random slight rotation for "messy" natural look
    final double angle = (text.length % 5 - 2) * 0.05;

    return Transform.rotate(
      angle: isDragging ? 0 : angle,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: Get.width * 0.85,
          height: 420,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(40),
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(80), // Large organic curve
            ),
            boxShadow: [
              if (!isDragging)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(8, 15),
                  spreadRadius: 2,
                ),
            ],
            // gradient removed to allow color to render
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 80)),
              const SizedBox(height: 30),
              Text(
                text,
                style: GoogleFonts.permanentMarker(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800], // Softer than pure black
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 60,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.brown[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Swipe (or Tap) to discard",
                style: GoogleFonts.caveat(
                  fontSize: 26,
                  color: Colors.brown[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
