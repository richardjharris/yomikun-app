import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:yomikun/quiz/models/question.dart';

void main() {
  const q = Question(
    text: '田中',
    subtext: 'Surname',
    answers: ['たなか'],
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

  test('Serialization', () {
    final copy = Question.fromMap(q.toMap());
    expect(copy.text, q.text);
    expect(copy.subtext, q.subtext);
    expect(copy.answers, q.answers);

    final copy2 = Question.fromMap(
        jsonDecode('{"text":"田中","subtext":"Surname","answers":["たなか"]}'));
    expect(copy2.text, q.text);
    expect(copy2.subtext, q.subtext);
    expect(copy2.answers, q.answers);
  });
}
