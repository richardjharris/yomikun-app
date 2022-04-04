import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/quiz/models/quiz_settings.dart';
import 'package:yomikun/quiz/models/quiz_state.dart';
import 'package:yomikun/quiz/services/quiz_generator.dart';
import 'package:yomikun/quiz/services/quiz_persistence_service.dart';
import 'package:yomikun/quiz/widgets/question_panel.dart';
import 'package:yomikun/quiz/widgets/quiz_progress_bar.dart';
import 'package:yomikun/quiz/widgets/screens/new_quiz_page.dart';
import 'package:yomikun/quiz/widgets/screens/quiz_summary_panel.dart';

/// Tests the user to see if they know the correct reading of common Japanese
/// names.
///
/// The basic mode is 10 questions picking fairly common names: any valid
/// readings will be accepted.
class QuizPage extends ConsumerStatefulWidget {
  static const routeName = '/quiz';

  const QuizPage();

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
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
      setState(() {});
    } catch (e, stack) {
      debugPrint("[RJH] Error loading quiz state, ignoring: ${e.toString()}");
      debugPrintStack(stackTrace: stack);
    }
  }

  Future<void> generateNewQuiz(QuizSettings settings) async {
    _quizState = QuizState(
      questions: await generateQuiz(settings, db: ref.watch(databaseProvider)),
    );
    setState(() {});
  }

  void resetQuiz() async {
    await QuizPersistenceService.clear();
    setState(() {
      _quizState = null;
    });
  }

  @override
  void dispose() async {
    // Must be done first, before async code
    super.dispose();

    if (_quizState != null) {
      debugPrint("[RJH] Saving quiz state");
      await QuizPersistenceService.persist(_quizState!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_quizState == null) {
      return NewQuizPage(onStart: (settings) => generateNewQuiz(settings));
    }

    final QuizState quiz = _quizState!;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.quiz),
        actions: [
          IconButton(
            onPressed: resetQuiz,
            icon: const Icon(Icons.refresh),
            tooltip: context.loc.qzTooltipNewQuiz,
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
                      onReset: resetQuiz,
                      onQuit: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : QuestionPanel(
                      quiz: quiz,
                      onAnswer: (answer) {
                        final correct =
                            quiz.currentQuestion.isCorrectAnswer(answer);
                        setState(() {
                          _quizState = quiz.answer(answer, correct);
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
