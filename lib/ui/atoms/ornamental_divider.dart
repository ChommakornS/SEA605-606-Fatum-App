import 'package:flutter/material.dart';

/// Atom: gold ornamental divider with fleuron centre glyph.
class OrnamentalDivider extends StatelessWidget {
  const OrnamentalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: const Color(0xFFD4AF37).withValues(alpha: 0.6),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '❧',
              style: TextStyle(color: const Color(0xFFD4AF37), fontSize: 18),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: const Color(0xFFD4AF37).withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
