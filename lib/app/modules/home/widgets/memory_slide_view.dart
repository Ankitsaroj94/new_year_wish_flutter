import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_image/magic_image.dart';

class MemorySlideView extends StatelessWidget {
  final String imagePath;
  final String caption;
  final TextStyle scriptStyle;

  const MemorySlideView({
    super.key,
    required this.imagePath,
    required this.caption,
    required this.scriptStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: Color(0xFFFFF0F5)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: Get.height * 0.9,
                        maxWidth: Get.width * 0.6,
                      ),
                      child: MagicImage(imagePath, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    caption,
                    style: scriptStyle.copyWith(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
