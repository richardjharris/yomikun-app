import 'package:flutter/material.dart';
import 'package:yomikun/quiz/models/quiz_state.dart';

/// Shows a progress bar indicating how many questions are complete and how
/// many remain.
///
/// Animates when the completed question count is increased.
class QuizProgressBar extends StatelessWidget {
  final QuizState quiz;

  const QuizProgressBar({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            GradientProgressIndicator(
              value: quiz.progressRatio,
              minHeight: 25,
              barStartColor: Colors.blueAccent,
              barEndColor: Colors.pinkAccent,
              backgroundColor: Colors.transparent,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 7, 5),
              child: Text('${quiz.questionsDone} / ${quiz.questionCount}'),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientProgressIndicator extends StatefulWidget {
  final Color barStartColor;
  final Color barEndColor;
  final Color backgroundColor;
  final double value;
  final double? minHeight;
  final Duration animateDuration;

  const GradientProgressIndicator({
    key,
    required this.barStartColor,
    required this.barEndColor,
    required this.backgroundColor,
    this.value = 0.0,
    this.minHeight,
    this.animateDuration = const Duration(milliseconds: 500),
  })  : assert(minHeight == null || minHeight > 0),
        super(key: key);

  @override
  _GradientProgressIndicatorState createState() =>
      _GradientProgressIndicatorState();
}

class _GradientProgressIndicatorState extends State<GradientProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curve;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animateDuration,
      vsync: this,
    );

    _curve = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

    // Disables the animation on initial load.
    _animation = AlwaysStoppedAnimation(widget.value);

    _controller.forward();
  }

  @override
  void didUpdateWidget(GradientProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animateDuration != widget.animateDuration) {
      _controller.duration = widget.animateDuration;
    }

    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(begin: oldWidget.value, end: widget.value)
          .animate(_curve);
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void stopAnimation() {
    _controller.stop();
  }

  Widget _buildIndicator(BuildContext context, double animationValue) {
    final ProgressIndicatorThemeData indicatorTheme =
        ProgressIndicatorTheme.of(context);
    final double minHeight =
        widget.minHeight ?? indicatorTheme.linearMinHeight ?? 4.0;

    return Container(
      constraints: BoxConstraints.tightFor(
        width: double.infinity,
        height: minHeight,
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        stops: <double>[
          0.0,
          animationValue,
          animationValue,
        ],
        colors: [
          widget.barStartColor,
          widget.barEndColor,
          widget.backgroundColor,
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return _buildIndicator(context, _animation.value);
      },
    );
  }
}
