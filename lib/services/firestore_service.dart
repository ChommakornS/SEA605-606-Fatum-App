import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/coven_post.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<CovenPost>> postsStream({String? topicFilter, String? userId}) {
    Query<Map<String, dynamic>> query = _db.collection('posts');

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    } else if (topicFilter != null && topicFilter != 'All') {
      query = query.where('topic', isEqualTo: topicFilter);
    } else {
      query = query.orderBy('createdAt', descending: true);
    }

    return query.snapshots().map((snap) {
      final posts = snap.docs.map(CovenPost.fromFirestore).toList();
      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return posts;
    });
  }

  Future<void> createPost(CovenPost post) async {
    await _db.collection('posts').add(post.toFirestore());
  }

  Future<void> updatePost(String postId, String reflectionText) async {
    await _db.collection('posts').doc(postId).update({
      'reflectionText': reflectionText,
    });
  }

  Future<void> deletePost(String postId) async {
    await _db.collection('posts').doc(postId).delete();
  }

  Future<void> toggleReaction(String postId, String userId) async {
    final ref = _db.collection('posts').doc(postId);
    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final likedBy = List<String>.from(snap.data()?['likedBy'] as List? ?? []);
      if (likedBy.contains(userId)) {
        likedBy.remove(userId);
      } else {
        likedBy.add(userId);
      }
      tx.update(ref, {
        'likedBy': likedBy,
        'reactionCount': likedBy.length,
      });
    });
  }

  // Replies subcollection
  Stream<List<CovenReply>> repliesStream(String postId) {
    return _db
        .collection('posts')
        .doc(postId)
        .collection('replies')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map(CovenReply.fromFirestore).toList());
  }

  Future<void> addReply(String postId, CovenReply reply) async {
    final batch = _db.batch();
    final replyRef = _db.collection('posts').doc(postId).collection('replies').doc();
    batch.set(replyRef, reply.toFirestore());
    batch.update(_db.collection('posts').doc(postId), {
      'replyCount': FieldValue.increment(1),
    });
    await batch.commit();
  }

  Future<void> deleteReply(String postId, String replyId) async {
    final batch = _db.batch();
    batch.delete(_db.collection('posts').doc(postId).collection('replies').doc(replyId));
    batch.update(_db.collection('posts').doc(postId), {
      'replyCount': FieldValue.increment(-1),
    });
    await batch.commit();
  }
}
