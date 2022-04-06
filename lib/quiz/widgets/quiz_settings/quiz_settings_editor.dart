import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yomikun/core/widgets/button_switch_bar.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/quiz/models/quiz_name_type.dart';
import 'package:yomikun/quiz/models/quiz_settings.dart';

/// Widget to edit the quiz s.
class QuizSettingsEditor extends HookWidget {
  final QuizSettings initialValue;
  final ValueChanged<QuizSettings> onDone;

  const QuizSettingsEditor({
    Key? key,
    required this.initialValue,
    required this.onDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = useState<QuizSettings>(initialValue);

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Title(context.loc.qzQuestionCountLabel),
          ButtonSwitchBar<int>(
            value: s.value.questionCount,
            onChanged: (value) =>
                s.value = s.value.copyWith(questionCount: value),
            items: [5, 10, 20, 50].map((v) => MapEntry('$v', v)).toList(),
          ),
          const SizedBox(height: 10),
          _Title(context.loc.qzDifficultyLabel),
          Slider(
            divisions: 9,
            min: 1,
            max: 10,
            value: s.value.difficulty.toDouble(),
            label: s.value.difficulty.toString(),
            onChanged: (value) =>
                s.value = s.value.copyWith(difficulty: value.toInt()),
          ),
          const SizedBox(height: 10),
          _Title(context.loc.qzNameTypeLabel),
          ButtonSwitchBar<QuizNameType>(
            value: s.value.nameType,
            onChanged: (value) => s.value = s.value.copyWith(nameType: value),
            items: QuizNameType.values
                .map((v) => MapEntry(v.description(context), v))
                .toList(),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => onDone(s.value),
            child: Text(context.loc.qzDoneChangingSettingsButton),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;

  const _Title(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
