import 'package:flutter/material.dart';
import '../data/tarot_data.dart';
import '../theme/app_theme.dart';

/// Mini tarot card thumbnail — shows card face image with ornate border.
/// Used in diary entries, coven posts, and reveal screen.
class CardThumbnail extends StatelessWidget {
  final int cardIndex;
  final bool isReversed;
  final double width;
  final double height;
  final String? label; // "Past" | "Present" | "Future"

  const CardThumbnail({
    super.key,
    required this.cardIndex,
    this.isReversed = false,
    this.width = 60,
    this.height = 100,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final card = kTarotDeck[cardIndex];

    return Column(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.5), width: 1),
            color: AppColors.cardBack,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: RotatedBox(
              quarterTurns: isReversed ? 2 : 0,
              child: Image.asset(
                card.assetPath,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Center(
                  child: Icon(Icons.auto_awesome, color: AppColors.gold, size: 20),
                ),
              ),
            ),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(
            label!,
            style: const TextStyle(
              fontFamily: 'Cinzel',
              fontSize: 9,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}
