import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Atom: pill-shaped filter chip used in Coven and Diary pages.
class GothicFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const GothicFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? Colors.white.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.cinzel(
            fontSize: 12,
            color: selected ? Colors.white : Colors.white60,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
