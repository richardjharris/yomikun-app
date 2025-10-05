// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yomikun/quiz/models/question.dart';
import 'package:yomikun/quiz/widgets/question_page/question_card.dart';
import 'package:yomikun/search/models/namedata.dart';
import 'package:yomikun/settings/settings_controller.dart';

/// Displays a [Card] with the question on one side and answer on the other.
///
/// When [showCardFront] is changed, will animate a flip to the other side of
/// the card.
class QuestionFlipCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final formatPref =
        ref.watch(settingsControllerProvider.select((p) => p.nameFormat));

    final readings =
        question.readings.map((r) => formatYomiString(r, formatPref));

    final front = QuestionCard(
      part: question.part,
      key: const ValueKey(false),
      child: Text(question.kanji,
          locale: const Locale('ja'), style: const TextStyle(fontSize: 180)),
    );

    final double backFontSize = readings.length == 1 ? 120 : 80;

    final back = QuestionCard(
      key: const ValueKey(true),
      child: Column(
        children: readings
            .map((yomi) => Text(yomi,
                locale: const Locale('ja'),
                style: TextStyle(fontSize: backFontSize)))
            .toList(),
      ),
    );

    return AnimatedSwitcher(
      duration: flipDuration,
      transitionBuilder: _transitionBuilder,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut.flipped,
      child: showCardFront ? front : back,
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
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }
}
