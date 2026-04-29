// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiaryEntryAdapter extends TypeAdapter<DiaryEntry> {
  @override
  final int typeId = 2;

  @override
  DiaryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiaryEntry(
      dateKey: fields[0] as String,
      topic: fields[1] as String,
      cards: (fields[2] as List).cast<DrawnCardRecord>(),
      reflectionNote: fields[3] as String?,
      timestamp: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DiaryEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dateKey)
      ..writeByte(1)
      ..write(obj.topic)
      ..writeByte(2)
      ..write(obj.cards)
      ..writeByte(3)
      ..write(obj.reflectionNote)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiaryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DrawnCardRecordAdapter extends TypeAdapter<DrawnCardRecord> {
  @override
  final int typeId = 3;

  @override
  DrawnCardRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DrawnCardRecord(
      cardIndex: fields[0] as int,
      cardName: fields[1] as String,
      romanNumeral: fields[2] as String,
      isReversed: fields[3] as bool,
      position: fields[4] as String,
      prophecyText: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DrawnCardRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.cardIndex)
      ..writeByte(1)
      ..write(obj.cardName)
      ..writeByte(2)
      ..write(obj.romanNumeral)
      ..writeByte(3)
      ..write(obj.isReversed)
      ..writeByte(4)
      ..write(obj.position)
      ..writeByte(5)
      ..write(obj.prophecyText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawnCardRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TodayReadingRecordAdapter extends TypeAdapter<TodayReadingRecord> {
  @override
  final int typeId = 4;

  @override
  TodayReadingRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodayReadingRecord(
      dateKey: fields[0] as String,
      topic: fields[1] as String,
      cardIndices: (fields[2] as List).cast<int>(),
      orientations: (fields[3] as List).cast<bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, TodayReadingRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dateKey)
      ..writeByte(1)
      ..write(obj.topic)
      ..writeByte(2)
      ..write(obj.cardIndices)
      ..writeByte(3)
      ..write(obj.orientations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodayReadingRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
