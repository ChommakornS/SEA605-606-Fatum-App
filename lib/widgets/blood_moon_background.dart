import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Full-screen gothic dark background with blood moon gradient overlay.
/// Used on Awakening page and Reading page.
class BloodMoonBackground extends StatelessWidget {
  final Widget child;

  const BloodMoonBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement blood moon background with gradient and decorative elements
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0416),
            AppColors.background,
          ],
        ),
      ),
      child: child,
    );
  }
}
