import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/quiz/models/quiz_state.dart';
import 'package:yomikun/quiz/widgets/question_page.dart';

/// Tests the user to see if they know the correct reading of common Japanese
/// names.
///
/// The basic mode is 10 questions picking fairly common names: any valid
/// readings will be accepted.
class QuizPage extends HookWidget {
  static const routeName = '/quiz';

  const QuizPage();

  @override
  Widget build(BuildContext context) {
    final quiz = QuizState.sample();

    /// Allow the QuestionPage to be forcibly re-created by changing its key.
    final key = useState<Key>(UniqueKey());

    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.quiz),
        actions: [
          IconButton(
              onPressed: () {
                key.value = UniqueKey();
              },
              icon: const Icon(Icons.refresh)),
          const SizedBox(width: 10),
        ],
      ),
      body: QuestionPage(
        key: key.value,
        question: quiz.questions.first,
        onFinish: (success) {
          debugPrint('[RJH] success = $success');
        },
      ),
    );
  }
}
