import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/quiz/models/quiz_state.dart';

/// Shows the quiz results and allows the quiz to be reset.
class QuizSummaryPanel extends StatelessWidget {
  final QuizState quiz;
  final VoidCallback onReset;
  final VoidCallback onQuit;

  const QuizSummaryPanel(
      {Key? key,
      required this.quiz,
      required this.onReset,
      required this.onQuit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _scoreBox(context),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8),
          child: _questionSummary(context),
        ),
        const Spacer(),
        _resetButton(),
        const SizedBox(height: 10),
        _quitButton(),
      ],
    );
  }

  Widget _scoreBox(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Your score',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Text(
              '${quiz.score} / ${quiz.questionsDone}',
              style: Theme.of(context).textTheme.headline2,
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _questionSummary(BuildContext context) {
    TextStyle value = const TextStyle(fontSize: 24);
    TextStyle header =
        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    // TODO change depending on kanji preference
    const comma = ', ';

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FixedColumnWidth(50),
      },
      children: [
        TableRow(
          children: [
            Text(context.loc.qzQuestion, style: header),
            Text(context.loc.qzAnswer, style: header),
            const Spacer(),
          ],
        ),
        TableRow(
          children: List.filled(3, const Divider()),
        ),
        ...quiz.questions.mapIndexed((index, question) {
          final wasCorrect = quiz.scores[index];
          return TableRow(
            children: [
              Text(question.kanji,
                  style: value, locale: const Locale('ja', 'JP')),
              Text(question.readings.join(comma), style: value),
              wasCorrect
                  ? Icon(Icons.done,
                      color: Colors.green, size: value.fontSize! * 1.5)
                  : Icon(Icons.close,
                      color: Colors.red, size: value.fontSize! * 1.5),
            ],
          );
        }),
      ],
    );
  }

  Widget _resetButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: TextButton(
        child: const Text('New Quiz'),
        onPressed: onReset,
      ),
    );
  }

  Widget _quitButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: TextButton(
        child: const Text('Quit'),
        onPressed: onQuit,
        autofocus: true,
      ),
    );
  }
}
