import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/shell_page.dart';
import '../../data/tarot_data.dart';
import '../../models/diary_entry.dart';
import '../../models/tarot_card.dart';
import '../../services/diary_service.dart';

class SpinRevealStep extends StatefulWidget {
  final ReadingTopic topic;
  final List<int> cardIndices;
  final List<bool> orientations;
  final VoidCallback onBack;

  const SpinRevealStep({
    super.key,
    required this.topic,
    required this.cardIndices,
    required this.orientations,
    required this.onBack,
  });

  @override
  State<SpinRevealStep> createState() => _SpinRevealStepState();
}

class _SpinRevealStepState extends State<SpinRevealStep>
    with TickerProviderStateMixin {
  late final List<AnimationController> _spinControllers;
  late final List<Animation<double>> _spinAnimations;

  final List<bool> _revealed = [false, false, false];
  bool _showProphecy = false;

  static const _spinDuration = Duration(milliseconds: 1400);
  static const _staggerDelay = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();

    _spinControllers = List.generate(
      3,
      (_) => AnimationController(vsync: this, duration: _spinDuration),
    );

    // 0 → 7 turns (3.5 full rotations = 1260°) with deceleration
    _spinAnimations = _spinControllers.map((ctrl) {
      return Tween<double>(begin: 0, end: 7 * pi * 2).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.easeOut),
      );
    }).toList();

    _startSpinSequence();
  }

  Future<void> _startSpinSequence() async {
    for (int i = 0; i < 3; i++) {
      if (i > 0) await Future.delayed(_staggerDelay);
      if (!mounted) return;
      final index = i;
      _spinControllers[index].forward().then((_) {
        if (!mounted) return;
        setState(() => _revealed[index] = true);
        if (index == 2) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) setState(() => _showProphecy = true);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    for (final c in _spinControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.transparent),
        SafeArea(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width * 0.7 : double.infinity,
              child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 56),
                Text(
                  'Your fate is sealed',
                  style: GoogleFonts.cinzel(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Three truths revealed',
                  style: GoogleFonts.cinzel(
                    fontSize: 13,
                    color: Colors.white54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    widget.topic.label,
                    style: GoogleFonts.cinzel(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // 3 spinning cards row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    3,
                    (i) => _SpinningCard(
                      cardIndex: widget.cardIndices[i],
                      isReversed: widget.orientations[i],
                      spinAnimation: _spinAnimations[i],
                      revealed: _revealed[i],
                      label: ['Past', 'Present', 'Future'][i],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Prophecy fades in after all spins
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 600),
                  opacity: _showProphecy ? 1.0 : 0.0,
                  child: _showProphecy
                      ? _ProphecySection(
                          topic: widget.topic,
                          cardIndices: widget.cardIndices,
                          orientations: widget.orientations,
                        )
                      : const SizedBox(height: 200),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
            ),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 48),
              child: IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.close, color: Colors.white54, size: 22),
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- Spinning card ---

class _SpinningCard extends StatelessWidget {
  final int cardIndex;
  final bool isReversed;
  final Animation<double> spinAnimation;
  final bool revealed;
  final String label;

  const _SpinningCard({
    required this.cardIndex,
    required this.isReversed,
    required this.spinAnimation,
    required this.revealed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final card = kTarotDeck[cardIndex];

    return Column(
      children: [
        SizedBox(
          width: 95,
          height: 145,
          child: AnimatedBuilder(
            animation: spinAnimation,
            builder: (context, child) {
              final angle = spinAnimation.value % (2 * pi);
              // Show back face while spinning in first half of each rotation
              final showBack = !revealed ||
                  (angle > pi / 2 && angle < 3 * pi / 2);

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(spinAnimation.value),
                child: showBack
                    ? _CardFace(
                        assetPath: 'assets/cards/back_card.png',
                        isReversed: false,
                      )
                    : _CardFace(
                        assetPath: card.assetPath,
                        isReversed: isReversed,
                      ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.cinzel(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
}

class _CardFace extends StatelessWidget {
  final String assetPath;
  final bool isReversed;

  const _CardFace({required this.assetPath, required this.isReversed});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: RotatedBox(
        quarterTurns: isReversed ? 2 : 0,
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          width: 95,
          height: 145,
          errorBuilder: (context, e, s) => Container(
            width: 95,
            height: 145,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1040),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Prophecy section ---

class _ProphecySection extends StatefulWidget {
  final ReadingTopic topic;
  final List<int> cardIndices;
  final List<bool> orientations;

  const _ProphecySection({
    required this.topic,
    required this.cardIndices,
    required this.orientations,
  });

  @override
  State<_ProphecySection> createState() => _ProphecySectionState();
}

class _ProphecySectionState extends State<_ProphecySection> {
  bool _sealed = false;
  bool _sealing = false;

  static const _positions = ['Past', 'Present', 'Future'];
  static const _positionSubs = [
    'What shaped you',
    'Where you stand',
    'What awaits you',
  ];

  String _dateKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  Future<void> _sealInDiary() async {
    if (_sealed || _sealing) return;
    setState(() => _sealing = true);

    final now = DateTime.now();
    final cards = List.generate(3, (i) {
      final card = kTarotDeck[widget.cardIndices[i]];
      return DrawnCardRecord(
        cardIndex: card.index,
        cardName: card.name,
        romanNumeral: card.romanNumeral,
        isReversed: widget.orientations[i],
        position: _positions[i].toLowerCase(),
        prophecyText: getProphecyText(
          cardIndex: widget.cardIndices[i],
          topicKey: widget.topic.key,
          isReversed: widget.orientations[i],
        ),
      );
    });

    final entry = DiaryEntry(
      dateKey: _dateKey(now),
      topic: widget.topic.label,
      cards: cards,
      timestamp: now,
    );

    await DiaryService().saveEntry(entry);

    if (mounted) {
      setState(() {
        _sealed = true;
        _sealing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sealed in your Blood Diary.',
            style: GoogleFonts.cinzel(fontSize: 12, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1A1040),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _shareToCoven() {
    ShellScope.of(context)?.openInscribeSheet(
      cardIndices: widget.cardIndices,
      orientations: widget.orientations,
      topic: widget.topic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(3, (i) {
          final card = kTarotDeck[widget.cardIndices[i]];
          final prophecy = getProphecyText(
            cardIndex: widget.cardIndices[i],
            topicKey: widget.topic.key,
            isReversed: widget.orientations[i],
          );
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ProphecyCard(
              position: _positions[i],
              positionSub: _positionSubs[i],
              card: card,
              isReversed: widget.orientations[i],
              prophecy: prophecy,
            ),
          );
        }),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _sealed || _sealing ? null : _sealInDiary,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(
                    color: _sealed ? Colors.white24 : Colors.white38,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _sealing
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            color: Colors.white54, strokeWidth: 2),
                      )
                    : Text(
                        _sealed ? 'SEALED' : 'SEAL IN DIARY',
                        style: GoogleFonts.cinzel(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: _sealed ? Colors.white38 : Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _shareToCoven,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D5BE3),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'SHARE TO COVEN',
                  style: GoogleFonts.cinzel(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProphecyCard extends StatelessWidget {
  final String position;
  final String positionSub;
  final TarotCard card;
  final bool isReversed;
  final String prophecy;

  const _ProphecyCard({
    required this.position,
    required this.positionSub,
    required this.card,
    required this.isReversed,
    required this.prophecy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$position - ${card.name}',
            style: GoogleFonts.cinzel(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: RotatedBox(
                  quarterTurns: isReversed ? 2 : 0,
                  child: Image.asset(
                    card.assetPath,
                    width: 52,
                    height: 78,
                    fit: BoxFit.cover,
                    errorBuilder: (context, e, s) => Container(
                      width: 52,
                      height: 78,
                      color: const Color(0xFF1A1040),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      positionSub,
                      style: GoogleFonts.cinzel(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      prophecy,
                      style: GoogleFonts.cinzel(
                        fontSize: 12,
                        color: Colors.white60,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
