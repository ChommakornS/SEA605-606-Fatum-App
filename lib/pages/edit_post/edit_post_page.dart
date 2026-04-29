import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/tarot_data.dart';
import '../../models/coven_post.dart';
import '../../services/firestore_service.dart';

class EditPostPage extends StatefulWidget {
  final CovenPost post;

  const EditPostPage({super.key, required this.post});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  late final TextEditingController _controller;
  final _firestoreService = FirestoreService();
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Reflection cannot be empty...');
      return;
    }
    setState(() {
      _isSaving = true;
      _error = null;
    });
    await _firestoreService.updatePost(widget.post.id, text);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => _DeleteDialog(onConfirm: () => Navigator.pop(ctx, true),
          onCancel: () => Navigator.pop(ctx, false)),
    );
    if (confirm == true && mounted) {
      await _firestoreService.deletePost(widget.post.id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.transparent),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width * 0.7 : double.infinity,
                child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Back nav
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        const Icon(Icons.chevron_left, color: Colors.white54, size: 16),
                        Text(
                          ' The Coven',
                          style: GoogleFonts.cinzel(fontSize: 12, color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Edit Your Prophecy',
                    style: GoogleFonts.cinzel(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Rewrite what the cards revealed',
                    style: GoogleFonts.cinzel(fontSize: 13, color: Colors.white54),
                  ),
                  const SizedBox(height: 20),
                  // Card spread preview
                  if (widget.post.cardData.isNotEmpty)
                    _SpreadPreview(post: widget.post),
                  const SizedBox(height: 20),
                  // Your reflection label
                  Text(
                    'Your reflection',
                    style: GoogleFonts.spectral(fontSize: 12, color: Colors.white54),
                  ),
                  const SizedBox(height: 6),
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
                      style: GoogleFonts.spectral(
                          fontSize: 13, color: Colors.white70, height: 1.6),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12),
                        counterStyle:
                            GoogleFonts.spectral(fontSize: 10, color: Colors.white24),
                        hintText: _error,
                        hintStyle: GoogleFonts.spectral(
                            fontSize: 12, color: const Color(0xFFCC2222)),
                      ),
                      onChanged: (_) {
                        if (_error != null) setState(() => _error = null);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Original reflection (read-only)
                  Text(
                    'Original reflection',
                    style: GoogleFonts.spectral(fontSize: 12, color: Colors.white54),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Text(
                      widget.post.reflectionText,
                      style: GoogleFonts.cinzel(
                        fontSize: 13,
                        color: Colors.white38,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D5BE3),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              'SAVE CHANGES',
                              style: GoogleFonts.cinzel(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Delete button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: _confirmDelete,
                      icon: const Icon(Icons.delete_outline,
                          color: Color(0xFFCC2222), size: 16),
                      label: Text(
                        'DELETE THIS PROPHECY',
                        style: GoogleFonts.cinzel(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: const Color(0xFFCC2222),
                          decoration: TextDecoration.lineThrough,
                          decorationColor: const Color(0xFFCC2222),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- Spread preview ---

class _SpreadPreview extends StatelessWidget {
  final CovenPost post;

  const _SpreadPreview({required this.post});

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
          SizedBox(
            width: 80,
            height: 52,
            child: Stack(
              children: List.generate(
                post.cardData.length.clamp(0, 3),
                (i) {
                  final assetPath = post.cardData[i]['assetPath'] as String? ??
                      kTarotDeck[post.cardData[i]['cardIndex'] as int].assetPath;
                  return Positioned(
                    left: i * 22.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        assetPath,
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
                  );
                },
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
                      post.topic,
                      style: GoogleFonts.cinzel(fontSize: 10, color: Colors.white60),
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

// --- Delete confirm dialog ---

class _DeleteDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _DeleteDialog({required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF111116),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Unseal this prophecy?',
              style: GoogleFonts.cinzel(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'This post will be removed from The Coven. The words cannot be unspoken.',
              style: GoogleFonts.cinzel(
                fontSize: 12,
                color: Colors.white54,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Yes, unseal it
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B1A1A),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Yes, unseal it',
                  style: GoogleFonts.cinzel(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFCC2222),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Keep it sealed
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Keep it sealed',
                  style: GoogleFonts.cinzel(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
