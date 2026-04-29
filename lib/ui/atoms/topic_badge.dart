import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Atom: small pill badge showing a topic label with icon.
class TopicBadge extends StatelessWidget {
  final String label;
  final IconData icon;

  const TopicBadge({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white54, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.cinzel(fontSize: 11, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
