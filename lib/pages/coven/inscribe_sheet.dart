import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/tarot_data.dart';
import '../../models/coven_post.dart';
import '../../models/tarot_card.dart';
import '../../services/firestore_service.dart';

class InscribeSheet extends StatefulWidget {
  /// Optional: pre-filled from Reveal screen
  final List<int>? cardIndices;
  final List<bool>? orientations;
  final ReadingTopic? topic;

  const InscribeSheet({
    super.key,
    this.cardIndices,
    this.orientations,
    this.topic,
  });

  @override
  State<InscribeSheet> createState() => _InscribeSheetState();
}

class _InscribeSheetState extends State<InscribeSheet> {
  final _controller = TextEditingController();
  final _firestoreService = FirestoreService();
  bool _isPosting = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _post() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Reflection cannot be empty...');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _isPosting = true;
      _error = null;
    });

    final cardIndices = widget.cardIndices ?? [];
    final orientations = widget.orientations ?? [];
    final topic = widget.topic?.label ?? 'All';

    final cardData = List.generate(cardIndices.length, (i) {
      final card = kTarotDeck[cardIndices[i]];
      return {
        'cardIndex': card.index,
        'cardName': card.name,
        'assetPath': card.assetPath,
        'isReversed': orientations.length > i ? orientations[i] : false,
        'position': ['past', 'present', 'future'][i],
      };
    });

    final post = CovenPost(
      id: '',
      userId: user.uid,
      username: user.displayName ?? user.email?.split('@').first ?? 'Unknown',
      topic: topic,
      reflectionText: text,
      cardData: cardData,
      createdAt: DateTime.now(),
    );

    await _firestoreService.createPost(post);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final hasSpread = widget.cardIndices != null && widget.cardIndices!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF080C1A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Inscribe Your Prophecy',
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                'Share with the coven',
                style: GoogleFonts.cinzel(fontSize: 12, color: Colors.white54),
              ),
            ),
            const SizedBox(height: 16),
            // Card spread preview (if available)
            if (hasSpread) ...[
              _SpreadPreview(
                cardIndices: widget.cardIndices!,
                topic: widget.topic,
              ),
              const SizedBox(height: 16),
            ],
            // Reflection label
            Text(
              'Your reflection',
              style: GoogleFonts.spectral(fontSize: 12, color: Colors.white54),
            ),
            const SizedBox(height: 6),
            // Text field
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _error != null
                      ? const Color(0xFFCC2222)
                      : Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: TextField(
                controller: _controller,
                maxLines: 5,
                maxLength: 500,
                style: GoogleFonts.spectral(fontSize: 13, color: Colors.white70, height: 1.6),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                  counterStyle: GoogleFonts.spectral(fontSize: 10, color: Colors.white24),
                  hintText: _error,
                  hintStyle: GoogleFonts.spectral(fontSize: 12, color: const Color(0xFFCC2222)),
                ),
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
              ),
            ),
            const SizedBox(height: 20),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'CANCEL',
                      style: GoogleFonts.cinzel(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isPosting ? null : _post,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D5BE3),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isPosting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'POST TO COVEN',
                            style: GoogleFonts.cinzel(
                              fontSize: 12,
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
        ),
      ),
    );
  }
}

// --- Spread preview ---

class _SpreadPreview extends StatelessWidget {
  final List<int> cardIndices;
  final ReadingTopic? topic;

  const _SpreadPreview({required this.cardIndices, this.topic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          // 3 card thumbnails stacked slightly
          SizedBox(
            width: 80,
            height: 52,
            child: Stack(
              children: List.generate(
                cardIndices.length.clamp(0, 3),
                (i) => Positioned(
                  left: i * 22.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      kTarotDeck[cardIndices[i]].assetPath,
                      width: 36,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (context, e, s) => Container(
                        width: 36,
                        height: 52,
                        color: const Color(0xFF1A1040),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tonight's 3-card spread",
                style: GoogleFonts.cinzel(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                'Past · Present · Future',
                style: GoogleFonts.cinzel(fontSize: 11, color: Colors.white54),
              ),
              if (topic != null) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.diamond_outlined, size: 10, color: Colors.white60),
                      const SizedBox(width: 4),
                      Text(
                        topic!.label,
                        style: GoogleFonts.cinzel(fontSize: 10, color: Colors.white60),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
