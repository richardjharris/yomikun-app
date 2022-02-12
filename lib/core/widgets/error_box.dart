import 'package:flutter/material.dart';
import 'package:yomikun/localization/app_localizations_context.dart';

/// Shows an error and prints the stack trace to the console.
class ErrorBox extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;

  const ErrorBox(this.error, this.stackTrace);

  @override
  Widget build(BuildContext context) {
    if (stackTrace != null) {
      debugPrintStack(stackTrace: stackTrace);
    }
    return Center(
      child: Text(
        '${context.loc.error}: $error',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.red,
        ),
      ),
    );
  }
}
