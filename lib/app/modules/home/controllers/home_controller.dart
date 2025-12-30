import 'dart:async';

import 'package:get/get.dart';
import 'package:new_year_wish_flutter/gen/assets.gen.dart';

import '../views/stages/declutter_view.dart';
import '../views/stages/golden_ticket_view.dart';
import '../views/stages/memory_vault_view.dart';
import '../views/stages/reveal_2026_view.dart';

class MemoryItem {
  final String imagePath;
  final String caption;
  MemoryItem(this.imagePath, this.caption);
}

class HomeController extends GetxController {
  // --- Stage 1: Gateway ---
  final RxDouble unlockProgress = 0.0.obs;
  Timer? _unlockTimer;

  void startUnlocking() {
    _unlockTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      unlockProgress.value += 0.05;
      if (unlockProgress.value >= 1.0) {
        stopUnlocking();
        _navigateToStage2();
      }
    });
  }

  void stopUnlocking() {
    _unlockTimer?.cancel();
    _unlockTimer = null;
    if (unlockProgress.value < 1.0) {
      unlockProgress.value = 0.0;
    }
  }

  void _navigateToStage2() {
    Get.to(
      () => const DeclutterView(),
      transition: Transition.circularReveal,
      duration: const Duration(milliseconds: 1000),
    );
  }

  // --- Stage 2: De-clutter ---
  final RxList<String> declutterItems = [
    'Work',
    'Stress',
    'Bad Days',
    'Distance',
  ].obs;

  void removeDeclutterItem(String item) {
    declutterItems.remove(item);
  }

  void openGift() {
    Get.to(
      () => const MemoryVaultView(),
      transition: Transition.zoom,
      duration: const Duration(milliseconds: 800),
    );
  }

  // --- Stage 3: Memory Vault ---
  final RxList<MemoryItem> memoryItems = <MemoryItem>[].obs;

  void _loadMemories() {
    // Cycling 9 images to make 15 cards
    final images = [
      Assets.images.a1.path,
      Assets.images.a2.path,
      Assets.images.a3.path,
      Assets.images.a4.path,
      Assets.images.a5.path,
      Assets.images.a6.path,
      Assets.images.a7.path,
      Assets.images.a8.path,
      Assets.images.a9.path,
    ];

    // Create 15 items
    for (int i = 0; i < 15; i++) {
      memoryItems.add(
        MemoryItem(images[i % images.length], "Memory #${i + 1}"),
      );
    }
  }

  RxInt swipedCount = 0.obs;

  void cycleMemoryCard() {
    if (memoryItems.isNotEmpty) {
      final item = memoryItems.removeAt(memoryItems.length - 1); // Take top
      memoryItems.insert(0, item); // Put at bottom

      swipedCount.value++;

      // Check if we have cycled through all items (plus 1 buffer or exact match?)
      // User said "when image reach to first and i swap then go next"
      // If we have 15 items, we want to go after 15th swipe?
      if (swipedCount.value >= 15) {
        // Hardcoded 15 based on _loadMemories
        // Trigger celebration and navigation
        _celebrateAndNavigate();
      }
    }
  }

  void _celebrateAndNavigate() {
    // Navigate after a small delay to let visual update happen or celebration start
    Future.delayed(const Duration(milliseconds: 1500), () {
      goToGoldenTicket();
    });
  }

  void goToGoldenTicket() {
    Get.to(() => const GoldenTicketView(), transition: Transition.fadeIn);
  }

  // --- Stage 4 to 5 ---
  void goToReveal2026() {
    Get.to(
      () => const Reveal2026View(),
      transition: Transition.rightToLeftWithFade,
    );
  }
}
