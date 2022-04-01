import 'package:flutter/material.dart';
import 'package:yomikun/core/widgets/loading_box.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/quiz/models/quiz_state.dart';
import 'package:yomikun/quiz/services/quiz_persistence_service.dart';
import 'package:yomikun/quiz/widgets/question_panel.dart';
import 'package:yomikun/quiz/widgets/quiz_progress_bar.dart';
import 'package:yomikun/quiz/widgets/quiz_summary_panel.dart';

/// Tests the user to see if they know the correct reading of common Japanese
/// names.
///
/// The basic mode is 10 questions picking fairly common names: any valid
/// readings will be accepted.
class QuizPage extends StatefulWidget {
  static const routeName = '/quiz';

  const QuizPage();

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  QuizState? _quizState;

  @override
  void initState() {
    super.initState();
    loadQuizState();
  }

  /// Load quiz state from persistent storage, or create a new one.
  void loadQuizState() async {
    try {
      _quizState = await QuizPersistenceService.load();
      _quizState ??= QuizState.sample();
    } catch (e, stack) {
      debugPrint("[RJH] Error loading quiz state, ignoring: ${e.toString()}");
      debugPrintStack(stackTrace: stack);
      _quizState = QuizState.sample();
    }
    setState(() {});
  }

  @override
  void dispose() async {
    if (_quizState != null) {
      await QuizPersistenceService.persist(_quizState!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_quizState == null) {
      return const LoadingBox();
    }

    final QuizState quiz = _quizState!;
    debugPrint('QuizPage.build() quizState = $_quizState');
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.quiz),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _quizState = QuizState.sampleTwo();
              });
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'New quiz',
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          QuizProgressBar(quiz: quiz),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: quiz.finished
                  ? QuizSummaryPanel(
                      quiz: quiz,
                      onReset: () {
                        setState(() {
                          _quizState = QuizState.sample();
                        });
                      },
                      onQuit: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : QuestionPanel(
                      key: ObjectKey(quiz.currentQuestion),
                      quiz: quiz,
                      onAnswer: (answer) {
                        final correct =
                            quiz.currentQuestion.isCorrectAnswer(answer);
                        setState(() {
                          _quizState = quiz.answer(correct);
                        });
                      },
                      onNextQuestion: () {
                        setState(() {
                          _quizState = quiz.nextQuestion();
                        });
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
