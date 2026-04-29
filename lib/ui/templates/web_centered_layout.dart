import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Template: constrains [child] to 70% of screen width on web, centered.
/// On mobile it renders full width. Wrap SafeArea content with this.
class WebCenteredLayout extends StatelessWidget {
  final Widget child;
  final double webFraction;

  const WebCenteredLayout({
    super.key,
    required this.child,
    this.webFraction = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * webFraction,
        child: child,
      ),
    );
  }
}
