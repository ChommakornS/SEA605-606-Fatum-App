import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Molecule: tappable pill that opens a bottom sheet option picker.
class PillDropdown extends StatelessWidget {
  final String value;
  final List<String> options;
  final void Function(String) onChanged;

  const PillDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showModalBottomSheet<String>(
          context: context,
          backgroundColor: const Color(0xFF111116),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options
                  .map((o) => ListTile(
                        title: Text(
                          o,
                          style: GoogleFonts.cinzel(
                            color: o == value ? Colors.white : Colors.white60,
                            fontWeight: o == value ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        onTap: () => Navigator.pop(context, o),
                      ))
                  .toList(),
            ),
          ),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: GoogleFonts.cinzel(fontSize: 12, color: Colors.white),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, color: Colors.white60, size: 14),
          ],
        ),
      ),
    );
  }
}
