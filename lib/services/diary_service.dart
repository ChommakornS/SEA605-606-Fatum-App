import 'package:hive_flutter/hive_flutter.dart';
import '../models/diary_entry.dart';

class DiaryService {
  static const _entriesBox = 'diary_entries';
  static const _todayBox = 'today_reading';

  Future<Box<DiaryEntry>> get _entries => Hive.openBox<DiaryEntry>(_entriesBox);
  Future<Box<TodayReadingRecord>> get _today =>
      Hive.openBox<TodayReadingRecord>(_todayBox);

  Future<List<DiaryEntry>> getAllEntries() async {
    final box = await _entries;
    final list = box.values.toList();
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  Future<DiaryEntry?> getTodayEntry() async {
    final key = _dateKey(DateTime.now());
    final box = await _entries;
    return box.get(key);
  }

  Future<void> saveEntry(DiaryEntry entry) async {
    final box = await _entries;
    // Use timestamp string as key so multiple readings per day are all stored
    await box.put(entry.timestamp.toIso8601String(), entry);
  }

  Future<bool> hasReadingToday() async {
    final box = await _today;
    return box.containsKey(_dateKey(DateTime.now()));
  }

  Future<TodayReadingRecord?> getTodayReading() async {
    final box = await _today;
    return box.get(_dateKey(DateTime.now()));
  }

  Future<void> saveTodayReading(TodayReadingRecord record) async {
    final box = await _today;
    await box.put(record.dateKey, record);
  }

  String _dateKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}
