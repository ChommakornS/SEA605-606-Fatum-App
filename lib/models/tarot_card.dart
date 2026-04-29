// Tarot card definitions and enums. TarotCard is a plain Dart class
// (not stored in Hive directly — the deck is a compile-time constant list).

class TarotCard {
  final int index; // 0–21
  final String name; // e.g. "The Fool"
  final String romanNumeral; // e.g. "0", "I", "XXI"
  final String assetPath; // assets/cards/00_the_fool.png

  const TarotCard({
    required this.index,
    required this.name,
    required this.romanNumeral,
    required this.assetPath,
  });
}

class DrawnCard {
  final int cardIndex;
  final String cardName;
  final String romanNumeral;
  final bool isReversed; // true = Taken orientation
  final String position; // "past" | "present" | "future"
  final String prophecyText;

  const DrawnCard({
    required this.cardIndex,
    required this.cardName,
    required this.romanNumeral,
    required this.isReversed,
    required this.position,
    required this.prophecyText,
  });

  Map<String, dynamic> toFirestore() => {
        'cardIndex': cardIndex,
        'cardName': cardName,
        'romanNumeral': romanNumeral,
        'isReversed': isReversed,
        'position': position,
      };
}

enum ReadingTopic {
  love,
  career,
  health,
  finance,
  study,
  lifePath,
}

extension ReadingTopicExtension on ReadingTopic {
  String get label {
    switch (this) {
      case ReadingTopic.love:
        return 'Love';
      case ReadingTopic.career:
        return 'Career';
      case ReadingTopic.health:
        return 'Health';
      case ReadingTopic.finance:
        return 'Finance';
      case ReadingTopic.study:
        return 'Study';
      case ReadingTopic.lifePath:
        return 'Life Path';
    }
  }

  String get subtitle {
    switch (this) {
      case ReadingTopic.love:
        return 'Romance · Connection';
      case ReadingTopic.career:
        return 'Work · Ambition';
      case ReadingTopic.health:
        return 'Body · Wellbeing';
      case ReadingTopic.finance:
        return 'Money · Luck';
      case ReadingTopic.study:
        return 'Growth · Learning';
      case ReadingTopic.lifePath:
        return 'Purpose · Destiny';
    }
  }

  String get key => name; // used for Hive/Firestore storage
}
