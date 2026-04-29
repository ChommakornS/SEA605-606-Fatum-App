import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/tarot_card.dart';

class TopicPicker extends StatefulWidget {
  final void Function(ReadingTopic topic) onTopicSelected;

  const TopicPicker({super.key, required this.onTopicSelected});

  @override
  State<TopicPicker> createState() => _TopicPickerState();
}

class _TopicPickerState extends State<TopicPicker> {
  ReadingTopic? _selected;

  static const _topics = [
    (ReadingTopic.love, Icons.favorite_border, 'Love', 'Romance · Connection'),
    (ReadingTopic.career, Icons.diamond_outlined, 'Career', 'Work · Ambition'),
    (ReadingTopic.health, Icons.star_border, 'Health', 'Body · Wellbeing'),
    (ReadingTopic.finance, Icons.radio_button_unchecked, 'Finance', 'Money · Luck'),
    (ReadingTopic.study, Icons.change_history_outlined, 'Study', 'Growth · Learning'),
    (ReadingTopic.lifePath, Icons.all_inclusive, 'Life Path', 'Purpose · Destiny'),
  ];

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
              const SizedBox(height: 60),
              Text(
                'What does fate speak to?',
                style: GoogleFonts.cinzel(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: GridView.count(
                    crossAxisCount: MediaQuery.of(context).size.width > 500 ? 3 : 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.2,
                    children: _topics.map((t) {
                      final (topic, icon, label, sub) = t;
                      final isSelected = _selected == topic;
                      return _TopicCard(
                        icon: icon,
                        label: label,
                        subtitle: sub,
                        selected: isSelected,
                        onTap: () {
                          setState(() => _selected = topic);
                          Future.delayed(const Duration(milliseconds: 150), () {
                            widget.onTopicSelected(topic);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopicCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _TopicCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? Colors.white.withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.12),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.cinzel(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.cinzel(
                fontSize: 9,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
