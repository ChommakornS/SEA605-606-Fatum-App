import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/tarot_card.dart';

class CardGridStep extends StatefulWidget {
  final ReadingTopic topic;
  final VoidCallback onBack;
  final void Function(List<int> cardIndices, List<bool> orientations) onReveal;

  const CardGridStep({
    super.key,
    required this.topic,
    required this.onBack,
    required this.onReveal,
  });

  @override
  State<CardGridStep> createState() => _CardGridStepState();
}

class _CardGridStepState extends State<CardGridStep>
    with TickerProviderStateMixin {
  // Slots: 0=Past, 1=Present, 2=Future. null = empty.
  final List<int?> _slots = [null, null, null];
  final List<bool> _orientations = [false, false, false];
  final Set<int> _usedCards = {};

  late final List<AnimationController> _floatControllers;
  late final List<Animation<double>> _floatAnimations;

  static const _slotLabels = ['Past', 'Present', 'Future'];

  bool get _allSlotsFilled => _slots.every((s) => s != null);

  // Index of next empty slot
  int get _nextEmptySlot => _slots.indexWhere((s) => s == null);

  @override
  void initState() {
    super.initState();
    _floatControllers = List.generate(22, (i) {
      final ctrl = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1800 + (i * 73) % 600),
      );
      Future.delayed(Duration(milliseconds: (i * 120) % 1200), () {
        if (mounted) ctrl.repeat(reverse: true);
      });
      return ctrl;
    });

    _floatAnimations = _floatControllers.map((ctrl) {
      return Tween<double>(begin: -4, end: 4).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (final c in _floatControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onCardTapped(int cardIndex) {
    if (_usedCards.contains(cardIndex)) return;
    final slot = _nextEmptySlot;
    if (slot == -1) return; // all slots full
    setState(() {
      _slots[slot] = cardIndex;
      _usedCards.add(cardIndex);
      _orientations[slot] = Random().nextBool();
    });
  }

  void _removeFromSlot(int slotIndex) {
    if (_slots[slotIndex] == null) return;
    setState(() {
      _usedCards.remove(_slots[slotIndex]);
      _slots[slotIndex] = null;
    });
  }

  void _reveal() {
    widget.onReveal(
      _slots.map((s) => s!).toList(),
      List.from(_orientations),
    );
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
              child: Column(
            children: [
              const SizedBox(height: 56),
              Text(
                'Blood Moon Reading',
                style: GoogleFonts.cinzel(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'The cards await your command',
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              _TopicBadge(topic: widget.topic),
              const SizedBox(height: 20),
              // Slots row — tap slot to remove card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    3,
                    (i) => _SlotWidget(
                      label: _slotLabels[i],
                      cardIndex: _slots[i],
                      onTap: () => _removeFromSlot(i),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Card grid — tap card to place in next empty slot
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: 22,
                      itemBuilder: (context, index) {
                        final isUsed = _usedCards.contains(index);
                        return _FloatingCard(
                          cardIndex: index,
                          isUsed: isUsed,
                          floatAnimation: _floatAnimations[index],
                          onTap: () => _onCardTapped(index),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Reveal button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _allSlotsFilled ? _reveal : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D5BE3),
                      disabledBackgroundColor:
                          const Color(0xFF2D5BE3).withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Reveal the fates',
                      style: GoogleFonts.cinzel(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
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

// --- Slot widget (tap to remove) ---

class _SlotWidget extends StatelessWidget {
  final String label;
  final int? cardIndex;
  final VoidCallback onTap;

  const _SlotWidget({
    required this.label,
    required this.cardIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: cardIndex != null ? onTap : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 90,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: cardIndex != null
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: cardIndex != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.asset(
                      'assets/cards/back_card.png',
                      fit: BoxFit.cover,
                    ),
                  )
                : null,
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

// --- Floating tappable card ---

class _FloatingCard extends StatelessWidget {
  final int cardIndex;
  final bool isUsed;
  final Animation<double> floatAnimation;
  final VoidCallback onTap;

  const _FloatingCard({
    required this.cardIndex,
    required this.isUsed,
    required this.floatAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: isUsed ? Offset.zero : Offset(0, floatAnimation.value),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isUsed ? 0.25 : 1.0,
            child: GestureDetector(
              onTap: isUsed ? null : onTap,
              child: child,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          'assets/cards/back_card.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// --- Topic badge ---

class _TopicBadge extends StatelessWidget {
  final ReadingTopic topic;

  const _TopicBadge({required this.topic});

  static const _icons = {
    ReadingTopic.love: Icons.favorite_border,
    ReadingTopic.career: Icons.diamond_outlined,
    ReadingTopic.health: Icons.star_border,
    ReadingTopic.finance: Icons.radio_button_unchecked,
    ReadingTopic.study: Icons.change_history_outlined,
    ReadingTopic.lifePath: Icons.all_inclusive,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icons[topic], color: Colors.white70, size: 14),
          const SizedBox(width: 6),
          Text(
            topic.label,
            style: GoogleFonts.cinzel(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
