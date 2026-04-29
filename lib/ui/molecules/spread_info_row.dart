import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../atoms/topic_badge.dart';

/// Molecule: card spread summary row — thumbnails + title + topic badge.
/// Used in diary entries, coven posts, and edit post page.
class SpreadInfoRow extends StatelessWidget {
  final Widget cardStack;
  final String title;
  final String subtitle;
  final String topicLabel;
  final IconData topicIcon;

  const SpreadInfoRow({
    super.key,
    required this.cardStack,
    required this.title,
    required this.subtitle,
    required this.topicLabel,
    required this.topicIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        cardStack,
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.cinzel(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.cinzel(fontSize: 11, color: Colors.white54),
              ),
              const SizedBox(height: 6),
              TopicBadge(label: topicLabel, icon: topicIcon),
            ],
          ),
        ),
      ],
    );
  }
}
