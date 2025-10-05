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
  QuizSettings _quizSettings = const QuizSettings();

  @override
  void initState() {
    super.initState();
    _loadQuizSettings();
  }

  Future<void> _loadQuizSettings() async {
    try {
      final savedSettings = await QuizPersistenceService.loadSettings();
      if (savedSettings != null && mounted) {
        setState(() {
          _quizSettings = savedSettings;
        });
      }
    } catch (e, stack) {
      debugPrint('[RJH] Error loading quiz settings, ignoring: $e\n$stack');
    }
  }

  Future<void> generateNewQuiz() async {
    final questions = await generateQuiz(
      settings: _quizSettings,
      db: ref.watch(databaseProvider),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _quizState = QuizState(
        questions: questions,
      );
    });
  }

  void _clearQuizState() {
    setState(() {
      _quizState = null;
    });
  }

  Future<void> _handleResetPressed() async {
    final quiz = _quizState;
    if (quiz == null) {
      _clearQuizState();
      return;
    }

    if (quiz.finished || await _confirmAbandonQuiz()) {
      _clearQuizState();
    }
  }

  void _handleQuitPressed() {
    _clearQuizState();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _confirmAbandonQuiz() async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.loc.qzAbandonQuizTitle),
        content: Text(context.loc.qzAbandonQuizMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.loc.cancelAction),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.loc.qzAbandonQuizConfirm),
          ),
        ],
      ),
    );

    return shouldLeave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Switcher: _quizState = $_quizState');
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _quizState == null ? _buildNewQuizPage() : _buildQuizPage(),
    );
  }

  Widget _buildNewQuizPage() {
    return NewQuizPage(
      settings: _quizSettings,
      onStart: generateNewQuiz,
      onChangeSettings: (settings) {
        setState(() {
          _quizSettings = settings;
          QuizPersistenceService.persistSettings(settings);
        });
      },
    );
  }

  Widget _buildQuizPage() {
    final QuizState quiz = _quizState!;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        if (didPop) return;
        if (await _onWillPopQuiz(quiz) && mounted) {
          // Either user confirmed abandoning quiz, or it's on the finish screen
          Navigator.of(context).pop();
        }
      },
      child: _buildQuizScaffold(quiz),
    );
  }

  Future<bool> _onWillPopQuiz(QuizState quiz) async {
    if (quiz.finished) {
      _clearQuizState();
      return true;
    }

    final shouldLeave = await _confirmAbandonQuiz();
    if (shouldLeave) {
      _clearQuizState();
    }
    return shouldLeave;
  }

  Widget _buildQuizScaffold(QuizState quiz) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.quiz),
        actions: [
          IconButton(
            onPressed: () {
              _handleResetPressed();
            },
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
                      onReset: () {
                        _clearQuizState();
                      },
                      onQuit: _handleQuitPressed,
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
