import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Molecule: segmented tab selector (e.g. Awakening / Rebirth on login page).
class TabSelector extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final void Function(int) onSelect;

  const TabSelector({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF0F1535) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: selected
                      ? Border.all(color: const Color(0xFF2D5BE3), width: 1.5)
                      : null,
                ),
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    color: selected ? Colors.white : Colors.white60,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
