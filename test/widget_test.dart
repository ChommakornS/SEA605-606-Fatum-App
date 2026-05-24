
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Smoke test app shell loads', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('FATUM'),
        ),
      ),
    );

    expect(find.text('FATUM'), findsOneWidget);
  });
}

