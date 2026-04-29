import 'package:flutter/material.dart';
import '../models/tarot_card.dart';
import '../theme/app_theme.dart';

/// Small pill badge displaying a reading topic.
class TopicBadge extends StatelessWidget {
  final ReadingTopic topic;

  const TopicBadge({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bloodMoon.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.bloodRed.withValues(alpha: 0.5)),
      ),
      child: Text(
        topic.label,
        style: const TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 10,
          color: AppColors.bloodRedLight,
          letterSpacing: 1,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
