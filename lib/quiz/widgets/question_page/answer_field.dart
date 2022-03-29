import 'package:flutter/material.dart';

/// Text field that accepts a short single line of text.
///
/// If [onSubmitted] is null, will display the submitted text (based on
/// [controller] in read-only form.
class AnswerField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;

  static const maxLength = 30;

  const AnswerField(
      {Key? key, this.controller, this.onSubmitted, this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        // Hide the '0/30' that would appear because [maxLength] is set.
        counterText: '',
        hintText: onSubmitted != null ? 'Enter answer' : 'No answer',
      ),
      enabled: onSubmitted != null,
      focusNode: focusNode,
      maxLines: 1,
      maxLength: maxLength,
      onEditingComplete: onSubmitted,
      textAlign: TextAlign.center,
    );
  }
}
