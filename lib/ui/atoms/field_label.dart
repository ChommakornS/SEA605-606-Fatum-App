import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Atom: small label above form fields.
class FieldLabel extends StatelessWidget {
  final String text;

  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.cinzel(fontSize: 13, color: Colors.white70),
    );
  }
}
