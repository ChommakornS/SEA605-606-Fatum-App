import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/tarot_card.dart';
import '../pages/reading/reading_page.dart';
import '../pages/coven/coven_page.dart';
import '../pages/coven/inscribe_sheet.dart';
import '../pages/diary/diary_page.dart';
import '../widgets/user_icon_dropdown.dart';
import '../ui/atoms/atoms.dart';

// --- InheritedWidget so any descendant can call ShellController ---

class ShellScope extends InheritedWidget {
  final ShellController controller;

  const ShellScope({
    super.key,
    required this.controller,
    required super.child,
  });

  static ShellController? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShellScope>()?.controller;

  @override
  bool updateShouldNotify(ShellScope old) => controller != old.controller;
}

// --- Controller ---

class ShellController {
  _ShellPageState? _state;

  void switchToTab(int index) => _state?._switchTab(index);

  void openInscribeSheet({
    List<int>? cardIndices,
    List<bool>? orientations,
    ReadingTopic? topic,
  }) =>
      _state?._openInscribeSheet(
        cardIndices: cardIndices,
        orientations: orientations,
        topic: topic,
      );
}

// --- Shell ---

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _currentIndex = 0;
  final ShellController _controller = ShellController();

  // Stable tab list — created once so IndexedStack preserves state
  late final List<Widget> _tabs;

  static const _labels = ['READING', 'THE COVEN', 'DIARY'];
  static const _icons = [
    Icons.auto_awesome,
    Icons.local_fire_department_outlined,
    Icons.menu_book_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _controller._state = this;
    _tabs = const [
      ReadingPage(),
      CovenPage(),
      DiaryPage(),
    ];
  }

  @override
  void dispose() {
    _controller._state = null;
    super.dispose();
  }

  void _switchTab(int index) => setState(() => _currentIndex = index);

  void _openInscribeSheet({
    List<int>? cardIndices,
    List<bool>? orientations,
    ReadingTopic? topic,
  }) {
    _switchTab(1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => InscribeSheet(
            cardIndices: cardIndices,
            orientations: orientations,
            topic: topic,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShellScope(
      controller: _controller,
      child: Scaffold(
        backgroundColor: const Color(0xFF080C1A),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/background/background.png',
                fit: BoxFit.cover,
                
              ),
            ),
            IndexedStack(
              index: _currentIndex,
              children: _tabs,
            ),
            const SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 12, right: 16),
                  child: UserIconDropdown(),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _GothicBottomNav(
          currentIndex: _currentIndex,
          labels: _labels,
          icons: _icons,
          onTap: _switchTab,
        ),
      ),
    );
  }
}

// --- Bottom nav ---

class _GothicBottomNav extends StatelessWidget {
  final int currentIndex;
  final List<String> labels;
  final List<IconData> icons;
  final void Function(int) onTap;

  const _GothicBottomNav({
    required this.currentIndex,
    required this.labels,
    required this.icons,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF080C1A),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const OrnamentalDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(labels.length, (i) {
                final isSelected = i == currentIndex;
                return GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icons[i],
                          size: 20,
                          color: isSelected ? Colors.white : Colors.white38,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          labels[i],
                          style: GoogleFonts.cinzel(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: isSelected ? Colors.white : Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

