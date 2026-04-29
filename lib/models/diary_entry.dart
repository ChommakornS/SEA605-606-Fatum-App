import 'package:hive/hive.dart';

part 'diary_entry.g.dart';

// Run `flutter pub run build_runner build` to generate diary_entry.g.dart

@HiveType(typeId: 2)
class DiaryEntry {
  @HiveField(0)
  final String dateKey; // "yyyy-MM-dd"

  @HiveField(1)
  final String topic;

  @HiveField(2)
  final List<DrawnCardRecord> cards; // 3 cards

  @HiveField(3)
  final String? reflectionNote;

  @HiveField(4)
  final DateTime timestamp;

  DiaryEntry({
    required this.dateKey,
    required this.topic,
    required this.cards,
    this.reflectionNote,
    required this.timestamp,
  });
}

@HiveType(typeId: 3)
class DrawnCardRecord {
  @HiveField(0)
  final int cardIndex;

  @HiveField(1)
  final String cardName;

  @HiveField(2)
  final String romanNumeral;

  @HiveField(3)
  final bool isReversed;

  @HiveField(4)
  final String position;

  @HiveField(5)
  final String prophecyText;

  DrawnCardRecord({
    required this.cardIndex,
    required this.cardName,
    required this.romanNumeral,
    required this.isReversed,
    required this.position,
    required this.prophecyText,
  });
}

@HiveType(typeId: 4)
class TodayReadingRecord {
  @HiveField(0)
  final String dateKey;

  @HiveField(1)
  final String topic;

  @HiveField(2)
  final List<int> cardIndices;

  @HiveField(3)
  final List<bool> orientations; // true = reversed

  TodayReadingRecord({
    required this.dateKey,
    required this.topic,
    required this.cardIndices,
    required this.orientations,
  });
}
