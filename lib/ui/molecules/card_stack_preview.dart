import 'package:flutter/material.dart';
import '../../data/tarot_data.dart';
import '../atoms/card_thumbnail.dart';

/// Molecule: overlapping stack of up to 3 card thumbnails.
/// Used in diary entries, coven posts, and edit post page.
class CardStackPreview extends StatelessWidget {
  final List<Map<String, dynamic>> cardData;
  final double width;
  final double height;
  final double offsetStep;

  const CardStackPreview({
    super.key,
    required this.cardData,
    this.width = 76,
    this.height = 52,
    this.offsetStep = 20,
  });

  @override
  Widget build(BuildContext context) {
    final count = cardData.length.clamp(0, 3);
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: List.generate(count, (i) {
          final data = cardData[i];
          final assetPath = data['assetPath'] as String? ??
              kTarotDeck[data['cardIndex'] as int].assetPath;
          final isReversed = data['isReversed'] as bool? ?? false;
          return Positioned(
            left: i * offsetStep,
            child: CardThumbnail(
              assetPath: assetPath,
              isReversed: isReversed,
              width: 34,
              height: 50,
            ),
          );
        }),
      ),
    );
  }
}
