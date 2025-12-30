import 'package:flutter/material.dart';

class OutroSlideView extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final TextStyle scriptStyle;
  final TextStyle bodyStyle;
  final Color primaryColor;

  const OutroSlideView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.scriptStyle,
    required this.bodyStyle,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color(0xFFFFE4E1), // Misty Rose
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 80, color: primaryColor),
              const SizedBox(height: 32),
              Text(title, style: scriptStyle, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              Text(subtitle, style: bodyStyle, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
