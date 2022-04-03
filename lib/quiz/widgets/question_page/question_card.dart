import 'package:flutter/material.dart';

/// [Card] that shows a question with optional sublabel.
class QuestionCard extends StatelessWidget {
  final String label;
  final String? sublabel;

  const QuestionCard(this.label, {this.sublabel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FittedBox(
                  child: Text(
                    label,
                    locale: const Locale('ja', 'JP'),
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
              if (sublabel != null)
                Container(
                  child: Text(
                    sublabel!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
