import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/quiz/models/quiz_state.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/settings/settings_controller.dart';

/// Shows the quiz results and allows the quiz to be reset.
class QuizSummaryPanel extends ConsumerStatefulWidget {
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
  _QuizSummaryPanelState createState() => _QuizSummaryPanelState();
}

class _QuizSummaryPanelState extends ConsumerState<QuizSummaryPanel> {
  late ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(
      duration: const Duration(seconds: 10),
    );
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    playConfettiForMaxScore();
  }

  @override
  void reassemble() {
    super.reassemble();
    playConfettiForMaxScore();
  }

  void playConfettiForMaxScore() {
    if (widget.quiz.gotPerfectScore) {
      debugPrint('[RJH] Perfect score!');
      _confetti.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            _scoreBox(context),
            Center(
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: true,
                colors: const [
                  Colors.lightGreen,
                  Colors.cyan,
                  Colors.pink,
                  Colors.yellow,
                  Colors.white,
                ],
                createParticlePath: drawStar,
              ),
            ),
          ],
        ),
        const Divider(),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: _questionSummary(context),
        )),
        Row(children: [
          Flexible(flex: 1, child: _resetButton(context)),
          Flexible(flex: 1, child: _quitButton(context)),
        ]),
      ],
    );
  }

  Widget _scoreBox(BuildContext context) {
    final quiz = widget.quiz;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              context.loc.qzYourScore,
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
    final quiz = widget.quiz;
    TextStyle value = const TextStyle(fontSize: 24);
    TextStyle header =
        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    final formatPref =
        ref.watch(settingsControllerProvider.select((p) => p.nameFormat));

    final correctIcon =
        Icon(Icons.done, color: Colors.green, size: value.fontSize! * 1.5);

    final incorrectIcon =
        Icon(Icons.close, color: Colors.red, size: value.fontSize! * 1.5);

    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(context.loc.qzQuestion, style: header),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(context.loc.qzAnswer, style: header),
            ),
            const SizedBox(width: 50),
          ],
        ),
        const Divider(),
        Expanded(
          // Taper off edge of list view to show it can be scrolled.
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              // We want roughly 30 pixels of taper
              final percent = min(1.0, 30.0 / bounds.height);

              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // Purple colour is not used (only its transparency)
                colors: const [Colors.transparent, Colors.purple],
                stops: [1 - percent, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstOut,
            child: ListView.separated(
              separatorBuilder: (_, __) => const Divider(),
              itemCount: quiz.questionCount + 1,
              itemBuilder: (context, index) {
                if (index == quiz.questionCount) {
                  // Return an empty box purely to hide the gradient crop effect.
                  return const SizedBox(height: 30);
                }

                final question = quiz.questions[index];
                final wasCorrect = quiz.scores[index];
                final readings = question.readings
                    .map((r) => formatYomiString(r, formatPref))
                    .join(nameJoinComma(formatPref));
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Text(question.kanji,
                          style: value, locale: const Locale('ja', 'JP')),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Text(readings, style: value),
                    ),
                    SizedBox(
                      width: 50,
                      child: wasCorrect ? correctIcon : incorrectIcon,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _resetButton(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: TextButton(
        child: Text(context.loc.qzSummaryNewQuizAction),
        onPressed: widget.onReset,
        autofocus: true,
      ),
    );
  }

  Widget _quitButton(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: TextButton(
        child: Text(context.loc.qzSummaryQuitAction),
        onPressed: widget.onQuit,
      ),
    );
  }
}

/// A custom Path to paint stars.
Path drawStar(Size size) {
  // Method to convert degree to radians
  double degToRad(double deg) => deg * (pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    path.lineTo(halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step));
    path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep));
  }
  path.close();
  return path;
}
