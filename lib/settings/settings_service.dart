import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yomikun/settings/models/settings_models.dart';

final settingsServiceProvider = Provider((_) => SettingsService());

class SettingsService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// Loads the user's preferred ThemeMode from local storage.
  Future<ThemeMode> themeMode() async {
    final SharedPreferences prefs = await _prefs;
    final String mode = prefs.getString('themeMode') ?? 'system';
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Persists the user's preferred ThemeMode to local storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('themeMode', theme.name);
  }

  Future<AppLanguagePreference> appLanguage() async {
    final SharedPreferences prefs = await _prefs;
    final String language = prefs.getString('appLanguage') ?? 'system';
    switch (language) {
      case 'en':
        return AppLanguagePreference.en;
      case 'ja':
        return AppLanguagePreference.ja;
      case 'system':
      default:
        return AppLanguagePreference.system;
    }
  }

  Future<void> updateAppLanguage(AppLanguagePreference language) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('appLanguage', language.name);
  }

  Future<NameVisualizationPreference> nameVisualization() async {
    final SharedPreferences prefs = await _prefs;
    final String nameVisualization = prefs.getString('nameVisualization') ?? '';
    switch (nameVisualization) {
      case 'pieChart':
        return NameVisualizationPreference.pieChart;
      case 'none':
        return NameVisualizationPreference.none;
      case 'treeMap':
      default:
        return NameVisualizationPreference.treeMap;
    }
  }

  Future<void> updateNameVisualization(
      NameVisualizationPreference nameVisualization) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('nameVisualization', nameVisualization.name);
  }
}
