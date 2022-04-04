import 'package:flutter/material.dart';
import 'package:yomikun/quiz/models/quiz_name_type.dart';
import 'package:yomikun/quiz/models/quiz_settings.dart';

/// Widget to display the quiz settings
class QuizSettingsOverview extends StatelessWidget {
  final QuizSettings settings;

  const QuizSettingsOverview({
    Key? key,
    required this.settings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Row('Questions', '${settings.questionCount}'),
        _Row('Difficulty', '${settings.difficulty}'),
        _Row('Type', settings.nameType.description(context)),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row(this.label, this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.grey, fontSize: 20);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(value, style: style),
        ],
      ),
    );
  }
}
