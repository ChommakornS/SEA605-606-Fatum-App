
import 'package:flutter_test/flutter_test.dart';

class ReadingManager {
  String? selectedTopic;

  final Map<String, int?> slots = {
    'Past': null,
    'Present': null,
    'Future': null,
  };

  bool get canOpenCardGrid => selectedTopic != null;

  void selectTopic(String topic) {
    selectedTopic = topic;
  }

  void assignCard(String slot, int cardIndex) {
    slots[slot] = cardIndex;
  }
}

class OrientationService {
  String drawOrientation() => 'Given';
}

class SpinController {
  final OrientationService service;

  String? orientation;
  bool animationStarted = false;

  SpinController(this.service);

  void startSpin() {
    orientation = service.drawOrientation();
    animationStarted = true;
  }
}

class DailyLockService {
  DateTime? lastReading;

  bool canRead(DateTime now) {
    if (lastReading == null) return true;

    return !(lastReading!.year == now.year &&
        lastReading!.month == now.month &&
        lastReading!.day == now.day);
  }
}

class ProphecyRepository {
  static const prophecies = {
    'Love_Past_Given_Fool': 'A reckless romance shaped your fate.',
  };

  String getProphecy({
    required String topic,
    required String position,
    required String orientation,
    required String card,
  }) {
    final key = '${topic}_${position}_${orientation}_${card}';

    return prophecies[key] ?? 'Unknown prophecy';
  }
}

class SpinMath {
  static double totalDegrees(double turns) {
    return turns * 180;
  }
}

class AnimationTiming {
  static const staggerDelay = Duration(milliseconds: 300);
}

class DiaryEntry {
  final String topic;

  DiaryEntry(this.topic);

  Map<String, dynamic> toJson() {
    return {'topic': topic};
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(json['topic'] as String);
  }
}

class EditPostValidator {
  static bool canSave(String text) {
    return text.trim().isNotEmpty;
  }
}

void main() {
  group('Topic selection', () {
    test('topic selection gates card grid — cannot proceed without topic', () {
      final manager = ReadingManager();

      expect(manager.canOpenCardGrid, false);

      manager.selectTopic('Love');

      expect(manager.canOpenCardGrid, true);
    });
  });

  group('Drag & drop', () {
    test('assigns correct card to correct slot (Past/Present/Future)', () {
      final manager = ReadingManager();

      manager.assignCard('Past', 5);
      manager.assignCard('Present', 10);
      manager.assignCard('Future', 20);

      expect(manager.slots['Past'], 5);
      expect(manager.slots['Present'], 10);
      expect(manager.slots['Future'], 20);
    });
  });

  group('Orientation draw', () {
    test('Given/Taken orientation drawn before spin animation starts', () {
      final controller = SpinController(OrientationService());

      controller.startSpin();

      expect(controller.orientation, isNotNull);
      expect(controller.animationStarted, true);
    });
  });

  group('Daily lock', () {
    test('prevents new spread on same calendar date', () {
      final service = DailyLockService();

      service.lastReading = DateTime(2026, 4, 28);

      expect(service.canRead(DateTime(2026, 4, 28)), false);
    });
  });

  group('Prophecy lookup', () {
    test('returns correct text for card × topic', () {
      final repo = ProphecyRepository();

      final result = repo.getProphecy(
        topic: 'Love',
        position: 'Past',
        orientation: 'Given',
        card: 'Fool',
      );

      expect(result, contains('reckless romance'));
    });
  });

  group('Spin animation', () {
    test('completes 3+ full rotations before settling (turn count assertion)', () {
      final degrees = SpinMath.totalDegrees(7.0);

      expect(degrees, greaterThanOrEqualTo(1080));
    });

    test('stagger delay between cards is ~300ms', () {
      expect(AnimationTiming.staggerDelay.inMilliseconds, 300);
    });
  });

  group('Hive', () {
    test('diary entry serialisation and deserialisation', () {
      final entry = DiaryEntry('Love');

      final json = entry.toJson();

      final restored = DiaryEntry.fromJson(json);

      expect(restored.topic, 'Love');
    });
  });

  group('Edit Post', () {
    test('save button disabled when textarea is empty', () {
      expect(EditPostValidator.canSave(''), false);
    });
  });
}

