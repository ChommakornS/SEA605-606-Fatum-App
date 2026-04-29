import 'package:flutter/material.dart';
import '../../models/tarot_card.dart';
import 'topic_picker.dart';
import 'card_grid.dart';
import 'spin_reveal.dart';

enum _ReadingStep { topic, pickCard, reveal }

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  _ReadingStep _step = _ReadingStep.topic;
  ReadingTopic? _topic;
  List<int>? _cardIndices;
  List<bool>? _orientations;

  @override
  Widget build(BuildContext context) {
    return switch (_step) {
      _ReadingStep.topic => TopicPicker(
          onTopicSelected: (topic) {
            setState(() {
              _topic = topic;
              _step = _ReadingStep.pickCard;
            });
          },
        ),
      _ReadingStep.pickCard => CardGridStep(
          topic: _topic!,
          onBack: () => setState(() => _step = _ReadingStep.topic),
          onReveal: (indices, orientations) {
            setState(() {
              _cardIndices = indices;
              _orientations = orientations;
              _step = _ReadingStep.reveal;
            });
          },
        ),
      _ReadingStep.reveal => SpinRevealStep(
          topic: _topic!,
          cardIndices: _cardIndices!,
          orientations: _orientations!,
          onBack: () => setState(() => _step = _ReadingStep.topic),
        ),
    };
  }
}
