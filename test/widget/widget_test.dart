// test/widget/widget_test.dart
//
// Widget Tests — FATUM App
// Course  : SEA606 Modern Software Testing
// Author  : Chommakorn Sontesadisai  68130702313
//
// Run: flutter test test/widget/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fatum/models/tarot_card.dart';
import 'package:fatum/pages/reading/topic_picker.dart';
import 'package:fatum/pages/reading/card_grid.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Root cause of timer issue:
//
// _CardGridStepState.initState() creates 22 Future.delayed timers:
//   Future.delayed(Duration(milliseconds: (i * 120) % 1200), () {
//     if (mounted) ctrl.repeat(reverse: true);  ← repeating animation
//   });
//
// The maximum delay is 1200ms. After each Future fires, it starts a
// *repeating* AnimationController. Both the pending Futures AND the
// repeating controllers count as "pending timers."
//
// Fix strategy: pump time PAST 1200ms so all Futures fire, THEN pump
// enough frames for the repeating animations to settle. We do this
// INSIDE the test body (not in addTearDown) so timers are drained
// before flutter_test checks invariants.
//
// We also call tester.pumpAndSettle() with a generous timeout so that
// any remaining animation frames are flushed before the test ends.
// ─────────────────────────────────────────────────────────────────────────────

/// Pump CardGridStep and drain all animation timers so tests can complete
/// cleanly without "A Timer is still pending" errors.
Future<void> pumpCardGrid(
  WidgetTester tester, {
  ReadingTopic topic = ReadingTopic.love,
  VoidCallback? onBack,
  void Function(List<int>, List<bool>)? onReveal,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CardGridStep(
          topic: topic,
          onBack: onBack ?? () {},
          onReveal: onReveal ?? (_, __) {},
        ),
      ),
    ),
  );

  // Step 1: advance clock past the longest Future.delayed (1200 ms)
  // so all 22 "start animation" timers fire.
  await tester.pump(const Duration(milliseconds: 1300));

  // Step 2: pump one more frame so the now-started AnimationControllers
  // register their first tick and flutter_test is aware of them.
  await tester.pump();
}

/// Drain all remaining timers/animations and dispose cleanly.
/// Call this at the END of every test that used pumpCardGrid().
Future<void> drainCardGrid(WidgetTester tester) async {
  // Replace widget tree with an empty scaffold — this disposes
  // CardGridStep and cancels its AnimationControllers via dispose().
  await tester.pumpWidget(const MaterialApp(home: Scaffold()));
  // Pump one final frame to let dispose() propagate.
  await tester.pump();
}

// ─────────────────────────────────────────────────────────────────────────────

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // WT-01 — TopicPicker
  // ═══════════════════════════════════════════════════════════════════════════
  group('WT-01 — TopicPicker', () {
    testWidgets('renders all 6 topic labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TopicPicker(onTopicSelected: (_) {}),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Love'),      findsOneWidget);
      expect(find.text('Career'),    findsOneWidget);
      expect(find.text('Health'),    findsOneWidget);
      expect(find.text('Finance'),   findsOneWidget);
      expect(find.text('Study'),     findsOneWidget);
      expect(find.text('Life Path'), findsOneWidget);
    });

    testWidgets('tapping "Love" calls onTopicSelected(ReadingTopic.love)',
        (tester) async {
      ReadingTopic? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TopicPicker(
              onTopicSelected: (t) => selected = t,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Love'));
      // TopicPicker uses Future.delayed(150ms) before firing callback
      await tester.pump(const Duration(milliseconds: 200));

      expect(selected, equals(ReadingTopic.love));
    });

    testWidgets('tapping "Career" calls onTopicSelected(ReadingTopic.career)',
        (tester) async {
      ReadingTopic? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TopicPicker(
              onTopicSelected: (t) => selected = t,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Career'));
      await tester.pump(const Duration(milliseconds: 200));

      expect(selected, equals(ReadingTopic.career));
    });

    testWidgets('renders all 6 subtitle texts', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TopicPicker(onTopicSelected: (_) {}),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Romance · Connection'), findsOneWidget);
      expect(find.text('Work · Ambition'),       findsOneWidget);
      expect(find.text('Body · Wellbeing'),      findsOneWidget);
      expect(find.text('Money · Luck'),          findsOneWidget);
      expect(find.text('Growth · Learning'),     findsOneWidget);
      expect(find.text('Purpose · Destiny'),     findsOneWidget);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // WT-02 — CardGridStep
  // ═══════════════════════════════════════════════════════════════════════════
  group('WT-02 — CardGridStep', () {
    testWidgets('renders title "Blood Moon Reading"', (tester) async {
      await pumpCardGrid(tester);
      expect(find.text('Blood Moon Reading'), findsOneWidget);
      await drainCardGrid(tester);
    });

    testWidgets('renders slot labels: Past, Present, Future', (tester) async {
      await pumpCardGrid(tester);
      expect(find.text('Past'),    findsOneWidget);
      expect(find.text('Present'), findsOneWidget);
      expect(find.text('Future'),  findsOneWidget);
      await drainCardGrid(tester);
    });

    testWidgets('renders "Reveal the fates" button', (tester) async {
      await pumpCardGrid(tester);
      expect(find.text('Reveal the fates'), findsOneWidget);
      await drainCardGrid(tester);
    });

    testWidgets('topic badge is rendered for the given topic', (tester) async {
      await pumpCardGrid(tester, topic: ReadingTopic.career);
      expect(find.text('Career'), findsWidgets);
      await drainCardGrid(tester);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // WT-03 — Reveal Button disabled state
  // ═══════════════════════════════════════════════════════════════════════════
  group('WT-03 — Reveal Button disabled state', () {
    testWidgets('Reveal button is disabled when 0/3 slots are filled',
        (tester) async {
      await pumpCardGrid(tester);

      final btn = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Reveal the fates'),
      );
      expect(btn.onPressed, isNull,
          reason: 'Button must be disabled until all 3 slots are filled');

      await drainCardGrid(tester);
    });

    testWidgets('onBack callback fires when close (×) button is tapped',
        (tester) async {
      bool backCalled = false;

      await pumpCardGrid(
        tester,
        topic: ReadingTopic.career,
        onBack: () => backCalled = true,
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(backCalled, isTrue,
          reason: 'Tapping × must call onBack');

      // drain BEFORE test ends — disposes AnimationControllers cleanly
      await drainCardGrid(tester);
    });
  });
}