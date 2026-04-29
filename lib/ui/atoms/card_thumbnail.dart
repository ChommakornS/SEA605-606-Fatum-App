import 'package:flutter/material.dart';
import '../../data/tarot_data.dart';

/// Atom: single tarot card thumbnail image.
class CardThumbnail extends StatelessWidget {
  final String assetPath;
  final bool isReversed;
  final double width;
  final double height;

  const CardThumbnail({
    super.key,
    required this.assetPath,
    this.isReversed = false,
    this.width = 34,
    this.height = 50,
  });

  /// Convenience constructor from card index.
  factory CardThumbnail.fromIndex({
    Key? key,
    required int cardIndex,
    bool isReversed = false,
    double width = 34,
    double height = 50,
  }) {
    return CardThumbnail(
      key: key,
      assetPath: kTarotDeck[cardIndex].assetPath,
      isReversed: isReversed,
      width: width,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: RotatedBox(
        quarterTurns: isReversed ? 2 : 0,
        child: Image.asset(
          assetPath,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, e, s) => Container(
            width: width,
            height: height,
            color: const Color(0xFF1A1040),
          ),
        ),
      ),
    );
  }
}
