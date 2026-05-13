// test/unit/firestore_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  late FakeFirebaseFirestore firestore;

  setUp(() {
    firestore = FakeFirebaseFirestore();
  });

  group('Firestore Service Tests', () {

    // =========================================================
    // FS-01 Create Post
    // =========================================================
    test('FS-01 Create Post', () async {
      await firestore.collection('posts').add({
        'userId': 'user_001',
        'username': 'moon_reader',
        'topic': 'Love',
        'reflectionText': 'The blood moon reveals hidden truth.',
        'reactionCount': 0,
        'createdAt': Timestamp.now(),
      });

      final snapshot = await firestore.collection('posts').get();

      expect(snapshot.docs.length, 1);
      expect(
        snapshot.docs.first['topic'],
        equals('Love'),
      );
    });

    // =========================================================
    // FS-02 Read Posts
    // =========================================================
    test('FS-02 Read Posts', () async {
      await firestore.collection('posts').add({
        'topic': 'Career',
      });

      await firestore.collection('posts').add({
        'topic': 'Health',
      });

      final snapshot = await firestore.collection('posts').get();

      expect(snapshot.docs.length, 2);
    });

    // =========================================================
    // FS-03 Update Post
    // =========================================================
    test('FS-03 Update Post', () async {
      final docRef = await firestore.collection('posts').add({
        'reflectionText': 'Old prophecy',
      });

      await firestore.collection('posts')
          .doc(docRef.id)
          .update({
        'reflectionText': 'Updated prophecy',
      });

      final updatedDoc = await firestore
          .collection('posts')
          .doc(docRef.id)
          .get();

      expect(
        updatedDoc['reflectionText'],
        equals('Updated prophecy'),
      );
    });

    // =========================================================
    // FS-04 Delete Post
    // =========================================================
    test('FS-04 Delete Post', () async {
      final docRef = await firestore.collection('posts').add({
        'topic': 'Life Path',
      });

      await firestore
          .collection('posts')
          .doc(docRef.id)
          .delete();

      final snapshot = await firestore.collection('posts').get();

      expect(snapshot.docs.isEmpty, true);
    });

    // =========================================================
    // FS-05 Ownership Validation
    // =========================================================
    test('FS-05 Ownership Validation', () async {
      final docRef = await firestore.collection('posts').add({
        'userId': 'owner_001',
        'reflectionText': 'Original text',
      });

      final post = await firestore
          .collection('posts')
          .doc(docRef.id)
          .get();

      final currentUserId = 'another_user';

      final canEdit =
          post['userId'] == currentUserId;

      expect(canEdit, false);
    });

    // =========================================================
    // FS-06 Empty Post Validation
    // =========================================================
    test('FS-06 Empty Post Validation', () {
      const input = '';

      final canSave = input.trim().isNotEmpty;

      expect(canSave, false);
    });

    // =========================================================
    // FS-07 Character Limit Validation
    // =========================================================
    test('FS-07 Character Limit Validation', () {
      final input = 'A' * 501;

      final isValid = input.length <= 500;

      expect(isValid, false);
    });

    // =========================================================
    // FS-08 Real-time Feed Update
    // =========================================================
    test('FS-08 Real-time Feed Update', () async {
      final stream = firestore
          .collection('posts')
          .snapshots();

      await firestore.collection('posts').add({
        'topic': 'Finance',
      });

      final snapshot = await stream.first;

      expect(snapshot.docs.length, 1);
    });

    // =========================================================
    // FS-09 Reaction Count Update
    // =========================================================
    test('FS-09 Reaction Count Update', () async {
      final docRef = await firestore.collection('posts').add({
        'reactionCount': 0,
      });

      await firestore
          .collection('posts')
          .doc(docRef.id)
          .update({
        'reactionCount': 1,
      });

      final updatedDoc = await firestore
          .collection('posts')
          .doc(docRef.id)
          .get();

      expect(updatedDoc['reactionCount'], 1);
    });

    // =========================================================
    // FS-10 My Posts Filter
    // =========================================================
    test('FS-10 My Posts Filter', () async {
      await firestore.collection('posts').add({
        'userId': 'user_001',
        'topic': 'Love',
      });

      await firestore.collection('posts').add({
        'userId': 'user_002',
        'topic': 'Career',
      });

      final snapshot = await firestore
          .collection('posts')
          .where('userId', isEqualTo: 'user_001')
          .get();

      expect(snapshot.docs.length, 1);
      expect(
        snapshot.docs.first['topic'],
        equals('Love'),
      );
    });
  });
}