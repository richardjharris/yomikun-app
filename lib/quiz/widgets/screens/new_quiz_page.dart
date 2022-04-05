import 'package:flutter/material.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/quiz/models/quiz_settings.dart';
import 'package:yomikun/quiz/widgets/quiz_settings/quiz_settings_editor.dart';
import 'package:yomikun/quiz/widgets/quiz_settings/quiz_settings_overview.dart';

class NewQuizPage extends StatelessWidget {
  final VoidCallback onStart;
  final ValueChanged<QuizSettings> onChangeSettings;
  final QuizSettings settings;

  const NewQuizPage({
    Key? key,
    required this.onStart,
    required this.settings,
    required this.onChangeSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.quiz),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ElevatedButton(
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child:
                        Text('Start New Quiz', style: TextStyle(fontSize: 36)),
                  ),
                  onPressed: onStart,
                ),
              ),
            ),
            QuizSettingsOverview(settings: settings),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: QuizSettingsEditor(
                      initialValue: settings,
                      onDone: (value) {
                        onChangeSettings(value);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Text('Change', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
