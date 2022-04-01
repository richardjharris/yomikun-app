import 'package:flutter/material.dart';
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
          child: _questionSummary(),
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

  Widget _questionSummary() {
    TextStyle value = const TextStyle(fontSize: 24);
    TextStyle header =
        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FixedColumnWidth(50),
      },
      children: [
        TableRow(
          children: [
            Text('Question', style: header),
            Text('Answer', style: header),
            const Spacer(),
          ],
        ),
        TableRow(
          children: List.filled(3, const Divider()),
        ),
        ...quiz.questions.map((question) {
          return TableRow(
            children: [
              Text(question.text, style: value),
              Text(question.answers.first, style: value),
              Icon(Icons.close, color: Colors.red, size: value.fontSize! * 1.5),
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
      child: ElevatedButton(
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
      ),
    );
  }
}
