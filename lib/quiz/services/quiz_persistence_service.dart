import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yomikun/quiz/models/quiz_settings.dart';
import 'package:yomikun/quiz/models/quiz_state.dart';

/// Persists the Quiz state across app restarts or if navigated away.
class QuizPersistenceService {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static const stateKey = 'quizState';
  static const settingsKey = 'quizSettings';

  /// Persists the quiz state.
  static Future<bool> persistState(QuizState quizState) async {
    final prefs = await _prefs;
    debugPrint('[RJH] Saving state: ${quizState.toJson()}');
    return prefs.setString(stateKey, quizState.toJson());
  }

  /// Clears any existing quiz state.
  static Future<bool> clearState() async {
    final prefs = await _prefs;
    return prefs.remove(stateKey);
  }

  /// Loads the quiz state.
  ///
  /// Returns [null] if there is no stored state.
  static Future<QuizState?> loadState() async {
    final prefs = await _prefs;
    if (prefs.containsKey(stateKey)) {
      debugPrint('[RJH] Got state: ${prefs.getString(stateKey)}');
      return QuizState.fromJson(prefs.getString(stateKey)!);
    } else {
      debugPrint('[RJH] Got no state.');
      return null;
    }
  }

  /// Persists the user's last used quiz settings.
  static Future<bool> persistSettings(QuizSettings settings) async {
    final prefs = await _prefs;
    debugPrint('[RJH] Saving quiz settings: ${settings.toJson()}');
    return prefs.setString(settingsKey, settings.toJson());
  }

  /// Loads the user's last used quiz settings.
  ///
  /// Returns [null] if there are no stored settings.
  static Future<QuizSettings?> loadSettings() async {
    final prefs = await _prefs;
    if (prefs.containsKey(settingsKey)) {
      debugPrint('[RJH] Got quiz settings: ${prefs.getString(settingsKey)}');
      return QuizSettings.fromJson(prefs.getString(settingsKey)!);
    } else {
      debugPrint('[RJH] Got no quiz settings.');
      return null;
    }
  }
}
