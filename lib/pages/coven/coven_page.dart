import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/tarot_data.dart';
import '../../models/coven_post.dart';
import '../../services/firestore_service.dart';
import '../../core/app_router.dart';
import 'inscribe_sheet.dart';

class CovenPage extends StatefulWidget {
  final bool autoOpenSheet;

  const CovenPage({super.key, this.autoOpenSheet = false});

  @override
  State<CovenPage> createState() => _CovenPageState();
}

class _CovenPageState extends State<CovenPage> {
  final _firestoreService = FirestoreService();
  String _activeFilter = 'All';
  bool _myPostOnly = false;
  late Stream<List<CovenPost>> _postsStream;

  static const _filters = ['All', 'Love', 'Career', 'Health', 'Finance', 'Study', 'Life Path'];

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  void _updateStream() {
    _postsStream = _firestoreService.postsStream(
      topicFilter: _myPostOnly ? null : (_activeFilter == 'All' ? null : _activeFilter),
      userId: _myPostOnly ? _currentUserId : null,
    );
  }

  @override
  void initState() {
    super.initState();
    _updateStream();
    if (widget.autoOpenSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openInscribeSheet());
    }
  }

  Future<void> _confirmDelete(BuildContext context, {required String message, required VoidCallback onConfirm}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Are you sure?',
          style: GoogleFonts.cinzel(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          style: GoogleFonts.cinzel(fontSize: 13, color: Colors.white60),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: GoogleFonts.cinzel(fontSize: 13, color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Remove', style: GoogleFonts.cinzel(fontSize: 13, color: const Color(0xFFCC2222))),
          ),
        ],
      ),
    );
    if (confirmed == true) onConfirm();
  }

  void _showReplySheet(BuildContext context, CovenPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReplySheet(post: post, currentUserId: _currentUserId),
    );
  }

  void _openInscribeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const InscribeSheet(),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 56),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The Coven',
                      style: GoogleFonts.cinzel(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Prophecies of the night',
                      style: GoogleFonts.cinzel(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Topic filter chips
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _filters.length,
                  separatorBuilder: (context, i) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final f = _filters[i];
                    final selected = !_myPostOnly && _activeFilter == f;
                    return _FilterChip(
                      label: f,
                      selected: selected,
                      onTap: () => setState(() {
                        _activeFilter = f;
                        _myPostOnly = false;
                        _updateStream();
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              // My Post chip
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _FilterChip(
                  label: 'My Post',
                  selected: _myPostOnly,
                  onTap: () => setState(() {
                    _myPostOnly = !_myPostOnly;
                    _updateStream();
                  }),
                ),
              ),
              const SizedBox(height: 12),
              // Feed
              Expanded(
                child: StreamBuilder<List<CovenPost>>(
                  stream: _postsStream,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white30),
                      );
                    }
                    final posts = snap.data ?? [];
                    if (posts.isEmpty) {
                      return Center(
                        child: Text(
                          'No prophecies yet.',
                          style: GoogleFonts.cinzel(color: Colors.white38, fontSize: 13),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: posts.length,
                      separatorBuilder: (context, i) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _PostCard(
                        post: posts[i],
                        currentUserId: _currentUserId,
                        onReact: () => _firestoreService.toggleReaction(posts[i].id, _currentUserId ?? ''),
                        onReply: () => _showReplySheet(context, posts[i]),
                        onEdit: () => Navigator.pushNamed(
                          context,
                          AppRoutes.editPost,
                          arguments: posts[i],
                        ),
                        onDelete: () => _confirmDelete(
                          context,
                          message: 'Remove this prophecy from The Coven?',
                          onConfirm: () => _firestoreService.deletePost(posts[i].id),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


// --- Post card ---

class _PostCard extends StatefulWidget {
  final CovenPost post;
  final String? currentUserId;
  final VoidCallback onReact;
  final VoidCallback onReply;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PostCard({
    required this.post,
    required this.currentUserId,
    required this.onReact,
    required this.onReply,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _showMenu = false;
  int _replyCount = 0;

  bool get _isOwn => widget.post.userId == widget.currentUserId;
  bool get _isLiked => widget.currentUserId != null && widget.post.likedBy.contains(widget.currentUserId);

  @override
  void initState() {
    super.initState();
    // Sync reply count from subcollection (handles old posts without replyCount field)
    FirestoreService().repliesStream(widget.post.id).listen((replies) {
      if (mounted) setState(() => _replyCount = replies.length);
    });
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final initial = post.username.trim().toUpperCase().characters.first;

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
          // Header row
          Row(
            children: [
              // Avatar
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.12),
                  border: Border.all(color: Colors.white24),
                ),
                alignment: Alignment.center,
                child: Text(
                  initial,
                  style: GoogleFonts.cinzel(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Name + time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      style: GoogleFonts.cinzel(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _timeAgo(post.createdAt),
                      style: GoogleFonts.cinzel(fontSize: 11, color: Colors.white38),
                    ),
                  ],
                ),
              ),
              // Topic badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white24),
                ),
                child: Text(
                  post.topic,
                  style: GoogleFonts.cinzel(fontSize: 11, color: Colors.white70),
                ),
              ),
              // ··· menu (own posts only)
              if (_isOwn) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => _showMenu = !_showMenu),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.more_horiz, color: Colors.white60, size: 16),
                  ),
                ),
              ],
            ],
          ),
          // Inline menu
          if (_isOwn && _showMenu) ...[
            const SizedBox(height: 10),
            _InlineMenu(
              onEdit: () {
                setState(() => _showMenu = false);
                widget.onEdit();
              },
              onDelete: () {
                setState(() => _showMenu = false);
                widget.onDelete();
              },
            ),
          ],
          const SizedBox(height: 10),
          // Card thumbnails
          if (post.cardData.isNotEmpty) ...[
            SizedBox(
              height: 52,
              child: Row(
                children: List.generate(post.cardData.length.clamp(0, 3), (i) {
                  final data = post.cardData[i];
                  final assetPath = data['assetPath'] as String? ??
                      kTarotDeck[data['cardIndex'] as int].assetPath;
                  final isReversed = data['isReversed'] as bool? ?? false;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: RotatedBox(
                        quarterTurns: isReversed ? 2 : 0,
                        child: Image.asset(
                          assetPath,
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
            const SizedBox(height: 10),
          ],
          // Reflection text
          Text(
            '"${post.reflectionText}"',
            style: GoogleFonts.cinzel(
              fontSize: 13,
              color: Colors.white70,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          // React + Reply row
          Row(
            children: [
              GestureDetector(
                onTap: widget.onReact,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isLiked
                        ? Colors.white.withValues(alpha: 0.18)
                        : Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isLiked
                          ? Colors.white.withValues(alpha: 0.5)
                          : Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isLiked ? Icons.diamond : Icons.diamond_outlined,
                        color: _isLiked ? Colors.white : Colors.white60,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.reactionCount}',
                        style: GoogleFonts.cinzel(
                          fontSize: 12,
                          color: _isLiked ? Colors.white : Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: widget.onReply,
                child: Text(
                  'reply ($_replyCount)',
                  style: GoogleFonts.cinzel(fontSize: 12, color: Colors.white54),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Filter chip ---

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? Colors.white.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.cinzel(
            fontSize: 12,
            color: selected ? Colors.white : Colors.white60,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// --- Inline edit/delete menu ---

class _InlineMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _InlineMenu({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D5A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onEdit,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.edit_outlined, color: Colors.white70, size: 16),
                  const SizedBox(width: 10),
                  Text(
                    'Edit prophecy',
                    style: GoogleFonts.cinzel(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.1)),
          InkWell(
            onTap: onDelete,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.delete_outline, color: Color(0xFFCC2222), size: 16),
                  const SizedBox(width: 10),
                  Text(
                    'Delete',
                    style: GoogleFonts.cinzel(fontSize: 13, color: Color(0xFFCC2222)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Reply sheet ---

class _ReplySheet extends StatefulWidget {
  final CovenPost post;
  final String? currentUserId;

  const _ReplySheet({required this.post, required this.currentUserId});

  @override
  State<_ReplySheet> createState() => _ReplySheetState();
}

class _ReplySheetState extends State<_ReplySheet> {
  final _controller = TextEditingController();
  final _firestoreService = FirestoreService();
  bool _sending = false;

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Future<void> _confirmDeleteReply(BuildContext context, String replyId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Are you sure?',
          style: GoogleFonts.cinzel(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Remove this reply?',
          style: GoogleFonts.cinzel(fontSize: 13, color: Colors.white60),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: GoogleFonts.cinzel(fontSize: 13, color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Remove', style: GoogleFonts.cinzel(fontSize: 13, color: const Color(0xFFCC2222))),
          ),
        ],
      ),
    );
    if (confirmed == true) await _firestoreService.deleteReply(widget.post.id, replyId);
  }

  Future<void> _sendReply() async {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.currentUserId == null) return;
    setState(() => _sending = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      final username = user?.displayName ?? user?.email?.split('@').first ?? 'Unknown';
      final reply = CovenReply(
        id: '',
        userId: widget.currentUserId!,
        username: username,
        text: text,
        createdAt: DateTime.now(),
      );
      await _firestoreService.addReply(widget.post.id, reply);
      _controller.clear();
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF111116),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  'Replies',
                  style: GoogleFonts.cinzel(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
              // Reply list
              Expanded(
                child: StreamBuilder<List<CovenReply>>(
                  stream: _firestoreService.repliesStream(widget.post.id),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white30));
                    }
                    final replies = snap.data ?? [];
                    if (replies.isEmpty) {
                      return Center(
                        child: Text(
                          'No replies yet. Be the first.',
                          style: GoogleFonts.cinzel(fontSize: 12, color: Colors.white38),
                        ),
                      );
                    }
                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: replies.length,
                      separatorBuilder: (context2, i) => Divider(
                        color: Colors.white.withValues(alpha: 0.07),
                        height: 20,
                      ),
                      itemBuilder: (_, i) {
                        final r = replies[i];
                        final initial = r.username.trim().toUpperCase().characters.first;
                        final isOwn = r.userId == widget.currentUserId;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.1),
                                border: Border.all(color: Colors.white24),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                initial,
                                style: GoogleFonts.cinzel(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        r.username,
                                        style: GoogleFonts.cinzel(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _timeAgo(r.createdAt),
                                        style: GoogleFonts.cinzel(
                                          fontSize: 10,
                                          color: Colors.white38,
                                        ),
                                      ),
                                      if (isOwn) ...[
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () => _confirmDeleteReply(context, r.id),
                                          child: const Icon(Icons.close, size: 14, color: Colors.white38),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    r.text,
                                    style: GoogleFonts.cinzel(
                                      fontSize: 13,
                                      color: Colors.white70,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              // Input
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                    top: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: GoogleFonts.cinzel(fontSize: 13, color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Whisper your reply...',
                            hintStyle: GoogleFonts.cinzel(fontSize: 13, color: Colors.white38),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.07),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          ),
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _sending ? null : _sendReply,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D5BE3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: _sending
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.send, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
