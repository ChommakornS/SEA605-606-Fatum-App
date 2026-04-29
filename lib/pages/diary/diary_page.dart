import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/diary_entry.dart';
import '../../data/tarot_data.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  static const _boxName = 'diary_entries';

  static const _topics = ['All', 'Love', 'Career', 'Health', 'Finance', 'Study', 'Life Path'];

  String _topicFilter = 'All';
  String _dateFilter = 'All';

  Box<DiaryEntry>? _box;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    final box = await Hive.openBox<DiaryEntry>(_boxName);
    if (mounted) setState(() => _box = box);
  }

  List<DiaryEntry> _filter(List<DiaryEntry> all) {
    final now = DateTime.now();
    return all.where((e) {
      // Date filter
      if (_dateFilter == '7 days' && now.difference(e.timestamp).inDays >= 7) return false;
      if (_dateFilter == '30 days' && now.difference(e.timestamp).inDays >= 30) return false;
      // Topic filter
      if (_topicFilter != 'All' && e.topic.toLowerCase() != _topicFilter.toLowerCase()) return false;
      return true;
    }).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  String _formatDate(DateTime dt) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final day = days[dt.weekday - 1];
    final month = months[dt.month - 1];
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$day ${dt.day} $month · $hour:$min';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 56),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Blood Diary',
                  style: GoogleFonts.cinzel(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _PillDropdown(
                      value: _dateFilter,
                      options: const ['All', '7 days', '30 days'],
                      onChanged: (v) => setState(() => _dateFilter = v),
                    ),
                    const SizedBox(width: 10),
                    _PillDropdown(
                      value: _topicFilter,
                      options: _topics,
                      onChanged: (v) => setState(() => _topicFilter = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildBody()),
            ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_box == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.white30));
    }

    return ValueListenableBuilder<Box<DiaryEntry>>(
      valueListenable: _box!.listenable(),
      builder: (context, box, _) {
        final entries = _filter(box.values.toList());
        if (entries.isEmpty) {
          return Center(
            child: Text(
              'No entries sealed yet.',
              style: GoogleFonts.cinzel(color: Colors.white38, fontSize: 13),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: entries.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (_, i) => _DiaryEntryCard(
            entry: entries[i],
            formatDate: _formatDate,
          ),
        );
      },
    );
  }
}

// --- Pill dropdown ---

class _PillDropdown extends StatelessWidget {
  final String value;
  final List<String> options;
  final void Function(String) onChanged;

  const _PillDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showModalBottomSheet<String>(
          context: context,
          backgroundColor: const Color(0xFF111116),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((o) => ListTile(
                title: Text(
                  o,
                  style: GoogleFonts.cinzel(
                    color: o == value ? Colors.white : Colors.white60,
                    fontWeight: o == value ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                onTap: () => Navigator.pop(context, o),
              )).toList(),
            ),
          ),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: GoogleFonts.cinzel(fontSize: 12, color: Colors.white),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, color: Colors.white60, size: 14),
          ],
        ),
      ),
    );
  }
}

// --- Entry card ---

class _DiaryEntryCard extends StatelessWidget {
  final DiaryEntry entry;
  final String Function(DateTime) formatDate;

  const _DiaryEntryCard({required this.entry, required this.formatDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 76,
                height: 52,
                child: Stack(
                  children: List.generate(entry.cards.length, (i) {
                    final card = kTarotDeck[entry.cards[i].cardIndex];
                    return Positioned(
                      left: i * 20.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: RotatedBox(
                          quarterTurns: entry.cards[i].isReversed ? 2 : 0,
                          child: Image.asset(
                            card.assetPath,
                            width: 34,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, e, s) => Container(
                              width: 34,
                              height: 50,
                              color: const Color(0xFF1A1040),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatDate(entry.timestamp),
                      style: GoogleFonts.cinzel(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Past · Present · Future',
                      style: GoogleFonts.cinzel(fontSize: 11, color: Colors.white54),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.diamond_outlined, color: Colors.white54, size: 11),
                          const SizedBox(width: 4),
                          Text(
                            entry.topic,
                            style: GoogleFonts.cinzel(fontSize: 11, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...entry.cards.map((c) => _CardProphecyBlock(card: c)),
        ],
      ),
    );
  }
}

// --- Card prophecy block ---

class _CardProphecyBlock extends StatelessWidget {
  final DrawnCardRecord card;

  const _CardProphecyBlock({required this.card});

  String get _positionLabel {
    switch (card.position.toLowerCase()) {
      case 'past': return 'Past';
      case 'present': return 'Present';
      case 'future': return 'Future';
      default: return card.position;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$_positionLabel – ${card.cardName}${card.isReversed ? ' (Reversed)' : ''}',
              style: GoogleFonts.cinzel(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              card.prophecyText,
              style: GoogleFonts.cinzel(
                fontSize: 12,
                color: Colors.white60,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

