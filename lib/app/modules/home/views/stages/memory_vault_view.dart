import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/home_controller.dart';
import '../../widgets/romantic_background.dart';

class MemoryVaultView extends StatefulWidget {
  const MemoryVaultView({super.key});

  @override
  State<MemoryVaultView> createState() => _MemoryVaultViewState();
}

class _MemoryVaultViewState extends State<MemoryVaultView> {
  late ConfettiController _confettiController;
  final HomeController controller = Get.find(); // Use instance

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    // Listen to swipedCount to trigger confetti
    ever(controller.swipedCount, (count) {
      if (count >= 15) {
        // Assuming 15 is the limit
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RomanticBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Our Memory Vault",
                    style: GoogleFonts.dancingScript(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Obx(() {
                        return Stack(
                          alignment: Alignment.center,
                          children: controller.memoryItems.asMap().entries.map((
                            entry,
                          ) {
                            final index = entry.key;
                            final item = entry.value;
                            final isTop =
                                index == controller.memoryItems.length - 1;

                            // Calculate Random Rotation based on index hash for consistency
                            final double rotation =
                                ((index * 13) % 10 - 5) * pi / 180;

                            return Positioned(
                              top:
                                  Get.height * 0.1 +
                                  (index * 2), // Adjusted stack position
                              child: Transform.rotate(
                                angle: rotation,
                                child: _buildDraggablePolaroid(item, isTop),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: TextButton(
                      onPressed: controller.goToGoldenTicket,
                      child: Text(
                        "The journey continues... >",
                        style: GoogleFonts.quicksand(color: Colors.white70),
                      ),
                    ),
                  ),
                ],
              ),

              // Confetti Overlay
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 5, // Reduced from default
                  colors: const [
                    Colors.red,
                    Colors.pink,
                    Colors.purple,
                    Colors.white,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDraggablePolaroid(MemoryItem item, bool isTop) {
    if (!isTop) {
      return _buildPolaroid(item); // Static back cards
    }

    return Draggable<MemoryItem>(
      data: item,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.rotate(
          // Maintain rotation visually while dragging
          angle: 0.1,
          child: _buildPolaroid(item),
        ),
      ),
      childWhenDragging:
          Container(), // Show nothing underneath (reveals next card)
      onDragStarted: () {
        // We could track start here if needed, but Draggable 'details.offset' is global.
        // Better: Compare with screen center (if card is centered).
        // Card is roughly centered.
      },
      onDragEnd: (details) {
        // Calculate distance from Center of Screen (since card is centered)
        // This is more robust than assuming (0,0) reference.
        final screenCenter = Offset(Get.width / 2, Get.height / 2);
        // Feedback is usually centered on finger or top-left.
        // Actually, details.offset is Top-Left of the feedback.
        // If feedback is 90% width, it's huge.
        // Let's use the center of the feedback rect.
        // Feedback Width ~ 0.9 * Get.width
        // Feedback Height ~ 0.65 * Get.height
        final feedbackCenter =
            details.offset + Offset(Get.width * 0.9 / 2, Get.height * 0.65 / 2);

        final distance = (feedbackCenter - screenCenter).distance;

        // Threshold
        if (distance > 100) {
          controller.cycleMemoryCard();
        }
      },
      child: _buildPolaroid(item),
    );
  }

  Widget _buildPolaroid(MemoryItem item) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      // Larger size
      width: Get.width * 0.9, // Almost full width
      height: Get.height * 0.65, // Taller
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
        borderRadius: BorderRadius.circular(
          2,
        ), // Sharp corners like photo paper
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Photo Content
          Column(
            children: [
              const SizedBox(height: 15), // Reduced top spacing
              Expanded(
                // Expand image to fill available space
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    color: Colors.grey[100],
                    child: Image.asset(
                      item.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      cacheWidth: 600, // Optimize memory usage
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Reduced spacing
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
                child: Text(
                  item.caption,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.coveredByYourGrace(
                    // Handwriting font
                    fontSize: 36, // Larger text
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          // "Tape" Visual
          Positioned(
            top: -15,
            child: Transform.rotate(
              angle: -0.1, // Slight tilt for tape
              child: Container(
                width: 100,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.4,
                  ), // Semi-transparent tape
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
