import 'package:cloud_firestore/cloud_firestore.dart';

class CovenPost {
  final String id;
  final String userId;
  final String username;
  final String topic;
  final String reflectionText;
  final List<Map<String, dynamic>> cardData;
  final DateTime createdAt;
  final int reactionCount;
  final List<String> likedBy;
  final int replyCount;

  const CovenPost({
    required this.id,
    required this.userId,
    required this.username,
    required this.topic,
    required this.reflectionText,
    required this.cardData,
    required this.createdAt,
    this.reactionCount = 0,
    this.likedBy = const [],
    this.replyCount = 0,
  });

  factory CovenPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CovenPost(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      username: data['username'] as String? ?? 'Unknown',
      topic: data['topic'] as String? ?? '',
      reflectionText: data['reflectionText'] as String? ?? '',
      cardData: List<Map<String, dynamic>>.from(
        (data['cardData'] as List?)?.map((e) => Map<String, dynamic>.from(e as Map)) ?? [],
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reactionCount: data['reactionCount'] as int? ?? 0,
      likedBy: List<String>.from(data['likedBy'] as List? ?? []),
      replyCount: data['replyCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'username': username,
        'topic': topic,
        'reflectionText': reflectionText,
        'cardData': cardData,
        'createdAt': Timestamp.fromDate(createdAt),
        'reactionCount': reactionCount,
        'likedBy': likedBy,
        'replyCount': replyCount,
      };

  CovenPost copyWith({String? reflectionText}) {
    return CovenPost(
      id: id,
      userId: userId,
      username: username,
      topic: topic,
      reflectionText: reflectionText ?? this.reflectionText,
      cardData: cardData,
      createdAt: createdAt,
      reactionCount: reactionCount,
      likedBy: likedBy,
      replyCount: replyCount,
    );
  }
}

class CovenReply {
  final String id;
  final String userId;
  final String username;
  final String text;
  final DateTime createdAt;

  const CovenReply({
    required this.id,
    required this.userId,
    required this.username,
    required this.text,
    required this.createdAt,
  });

  factory CovenReply.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CovenReply(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      username: data['username'] as String? ?? 'Unknown',
      text: data['text'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'username': username,
        'text': text,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
