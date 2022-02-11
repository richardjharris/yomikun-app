import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_service.dart';

final settingsControllerProvider = ChangeNotifierProvider((ref) {
  final service = ref.read(settingsServiceProvider);

  return SettingsController(service);
});

class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;

  late ThemeMode _themeMode;
  late AppLanguagePreference _appLanguage;

  /// Returns the user's preferred [ThemeMode].
  ThemeMode get themeMode => _themeMode;

  /// Returns the user's preferred language for the application.
  AppLanguagePreference get appLanguage => _appLanguage;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _appLanguage = await _settingsService.appLanguage();

    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    notifyListeners();
    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> updateAppLanguage(AppLanguagePreference? language) async {
    if (language == null) return;
    if (language == _appLanguage) return;

    _appLanguage = language;
    notifyListeners();
    await _settingsService.updateAppLanguage(language);
  }

  Locale? appLocale() {
    switch (appLanguage) {
      case AppLanguagePreference.en:
        return const Locale('en');
      case AppLanguagePreference.ja:
        return const Locale('ja');
      case AppLanguagePreference.system:
        return null;
    }
  }
}
