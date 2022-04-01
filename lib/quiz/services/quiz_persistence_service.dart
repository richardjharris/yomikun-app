import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yomikun/quiz/models/quiz_state.dart';

/// Persists the Quiz state across app restarts or if navigated away.
class QuizPersistenceService {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static const prefKey = 'quizState';

  /// Persists the quiz state.
  static Future<bool> persist(QuizState quizState) async {
    final prefs = await _prefs;
    return prefs.setString(prefKey, quizState.toJson());
  }

  /// Loads the quiz state.
  ///
  /// Returns [null] if there is no stored state.
  static Future<QuizState?> load() async {
    final prefs = await _prefs;
    if (prefs.containsKey(prefKey)) {
      debugPrint('[RJH] ${prefs.getString(prefKey)}');
      return QuizState.fromJson(prefs.getString(prefKey)!);
    } else {
      return null;
    }
  }
}
