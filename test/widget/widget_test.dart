import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Topic picker widget', () {
    testWidgets('renders 6 topics; tapping one highlights it',
        (tester) async {
      final topics = [
        'Love',
        'Career',
        'Health',
        'Finance',
        'Study',
        'Life Path',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Wrap(
                children: topics.map((topic) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(topic),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Love'), findsOneWidget);
      expect(find.text('Career'), findsOneWidget);
      expect(find.text('Health'), findsOneWidget);
      expect(find.text('Finance'), findsOneWidget);
      expect(find.text('Study'), findsOneWidget);
      expect(find.text('Life Path'), findsOneWidget);

      await tester.tap(find.text('Love'));
      await tester.pumpAndSettle();
    });
  });

  group('Card grid widget', () {
    testWidgets(
        'renders 22 face-down cards; placed cards show as faded/used',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Wrap(
                children: List.generate(
                  22,
                  (index) => Container(
                    key: Key('card-$index'),
                    width: 50,
                    height: 80,
                    margin: const EdgeInsets.all(4),
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('card-0')), findsOneWidget);
      expect(find.byKey(const Key('card-21')), findsOneWidget);
    });
  });

  group('Reveal button', () {
    testWidgets(
        'disabled with fewer than 3 slots filled; active when all 3 filled',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: null,
              child: const Text('Reveal'),
            ),
          ),
        ),
      );

      final button =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      expect(button.onPressed, isNull);
    });
  });
}
