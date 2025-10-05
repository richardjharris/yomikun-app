import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yomikun/quiz/models/quiz_settings.dart';

/// Persists quiz configuration, avoiding long-lived quiz progress.
class QuizPersistenceService {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static const settingsKey = 'quizSettings';

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
