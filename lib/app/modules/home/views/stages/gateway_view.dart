import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/home_controller.dart';
import '../../widgets/romantic_background.dart';

class GatewayView extends GetView<HomeController> {
  const GatewayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RomanticBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                    "Hold to Unlock My Heart",
                    style: GoogleFonts.dancingScript(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: const Duration(seconds: 1))
                  .shimmer(),
              const SizedBox(height: 50),
              GestureDetector(
                onLongPressStart: (_) => controller.startUnlocking(),
                onLongPressEnd: (_) => controller.stopUnlocking(),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background / Empty Heart
                    const Icon(
                      Icons.favorite_border,
                      color: Colors.white30,
                      size: 150,
                    ),

                    // Filled Heart (Clipped by progress)
                    Obx(() {
                      final progress = controller.unlockProgress.value;
                      // Pulse effect that gets faster as progress increases
                      final pulseSpeed = 1000 - (progress * 800).toInt();

                      return ClipRect(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              heightFactor: progress,
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.pinkAccent,
                                size: 150,
                              ),
                            ),
                          )
                          .animate(target: progress > 0 ? 1 : 0)
                          .scale(
                            begin: const Offset(1.0, 1.0),
                            end: const Offset(1.1, 1.1),
                            duration: Duration(
                              milliseconds: pulseSpeed < 100 ? 100 : pulseSpeed,
                            ),
                            curve: Curves.easeInOut,
                          );
                    }),

                    // Particles/Sparkles on top if almost done?
                    // Keeping it simple for now as requested: "filling heart"
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Optional: Hint text or small indicator
              Obx(
                () => Opacity(
                  opacity: controller.unlockProgress.value > 0 ? 1.0 : 0.0,
                  child: Text(
                    "${(controller.unlockProgress.value * 100).toInt()}%",
                    style: GoogleFonts.quicksand(color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
