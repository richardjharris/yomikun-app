import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:yomikun/quiz/models/question.dart';
import 'package:yomikun/search/models.dart';

void main() {
  const q = Question(
    kanji: '田中',
    part: NamePart.sei,
    readings: ['たなか'],
  );

  test('isCorrectAnswer', () {
    expect(q.isCorrectAnswer('たなか'), true);
    expect(q.isCorrectAnswer('たなか '), true);
    expect(q.isCorrectAnswer('　たなか'), true);
    //expect(q.isCorrectAnswer('タナカ'), true);
    expect(q.isCorrectAnswer('tanaka'), true);
    expect(q.isCorrectAnswer('Tanaka'), true);
    expect(q.isCorrectAnswer('だなか '), false);
    expect(q.isCorrectAnswer('danaka'), false);
  });

  test('isCorrectAnswer (nn)', () {
    const ken = Question(
      kanji: '健一',
      part: NamePart.mei,
      readings: ['けんいち'],
    );
    expect(ken.isCorrectAnswer('けんいち'), true);
    expect(ken.isCorrectAnswer('けんにち'), false, reason: 'kana input is strict');
    expect(ken.isCorrectAnswer('kennichi'), true);
    expect(ken.isCorrectAnswer("ken'ichi"), true);
    expect(ken.isCorrectAnswer('kenichi'), true,
        reason: 'romaji input is permissive');
    expect(ken.isCorrectAnswer('tanaka'), false);
  });

  test('Serialization', () {
    final copy = Question.fromMap(q.toMap());
    expect(copy.kanji, q.kanji);
    expect(copy.part, q.part);
    expect(copy.readings, q.readings);

    final copy2 = Question.fromMap(
        jsonDecode('{"kanji":"田中","part":"sei","readings":["たなか"]}'));
    expect(copy2.kanji, q.kanji);
    expect(copy2.part, q.part);
    expect(copy2.readings, q.readings);
  });
}
