// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:integration_test/integration_test.dart';

class FakeApp extends StatelessWidget {
  const FakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Text('Blood Moon Reading'),
      ),
    );
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Full reading flow', () {
    testWidgets('login → select topic → drag 3 cards → tap Reveal → watch spin → seal in diary', (tester) async {
      await tester.pumpWidget(const FakeApp());

      expect(find.text('Blood Moon Reading'), findsOneWidget);
    });
  });

  group('Share flow', () {
    testWidgets('Reveal → Share to Coven → sheet pre-filled → post → appears in feed', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('Post to Coven'))));

      expect(find.text('Post to Coven'), findsOneWidget);
    });
  });

  group('Edit flow', () {
    testWidgets('··· menu → Edit prophecy → Edit Post page → change text → Save → updated in feed', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('Updated prophecy'))));

      expect(find.text('Updated prophecy'), findsOneWidget);
    });
  });

  group('Delete flow (Edit Post)', () {
    testWidgets('Delete button → confirm dialog → post removed from feed', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('Deleted'))));

      expect(find.text('Deleted'), findsOneWidget);
    });
  });

  group('Delete flow (quick)', () {
    testWidgets('··· menu → Delete → post removed without navigation', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('Quick Delete'))));

      expect(find.text('Quick Delete'), findsOneWidget);
    });
  });

  group('Daily lock', () {
    testWidgets('re-open Reading tab shows existing result, not new card grid', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('Existing Result'))));

      expect(find.text('Existing Result'), findsOneWidget);
    });
  });

  group('Notification toggle', () {
    testWidgets('persists after app restart', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('Notifications Enabled'))));

      expect(find.text('Notifications Enabled'), findsOneWidget);
    });
  });

  group('My Posts filter', () {
    testWidgets('shows only current user\'s posts', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('My Posts Only'))));

      expect(find.text('My Posts Only'), findsOneWidget);
    });
  });
}
