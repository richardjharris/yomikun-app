// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yomikun/quiz/models/question.dart';
import 'package:yomikun/quiz/widgets/question_page/question_card.dart';

/// Displays a [Card] with the question on one side and answer on the other.
///
/// When [showCardFront] is changed, will animate a flip to the other side of
/// the card.
class QuestionFlipCard extends StatelessWidget {
  /// Question to display.
  final Question question;

  /// Whether to show the front (question) or back (answer) of the card. If this
  /// value is changed, the card will be flipped with an animation.
  final bool showCardFront;

  /// Duration for the flip animation.
  final Duration flipDuration;

  /// Callback invoked when the flip has been completed.
  final VoidCallback? onFlipCompleted;

  const QuestionFlipCard({
    Key? key,
    required this.question,
    required this.showCardFront,
    required this.flipDuration,
    this.onFlipCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final front = QuestionCard(question.text,
        sublabel: question.subtext, key: const ValueKey(false));
    final back =
        QuestionCard(question.answers.join('、'), key: const ValueKey(true));

    return AnimatedSwitcher(
      duration: flipDuration,
      transitionBuilder: _transitionBuilder,
      child: showCardFront ? front : back,
      switchInCurve: Curves.easeInBack,
      switchOutCurve: Curves.easeInBack.flipped,
    );
  }

  Widget _transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);

    if (onFlipCompleted != null) {
      rotateAnim.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          onFlipCompleted!();
        }
      });
    }

    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(showCardFront) != widget!.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }
}
