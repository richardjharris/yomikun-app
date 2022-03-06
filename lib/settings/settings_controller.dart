import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yomikun/settings/models/settings_models.dart';

import 'settings_service.dart';

/// Provider for the settings controller. Updates all listeners when settings
/// are changed; use Riverpod `select` for more fine-grained control.
final settingsControllerProvider = ChangeNotifierProvider((ref) {
  final service = ref.read(settingsServiceProvider);

  return SettingsController(service);
});

/// Settings interface for UI code.
///
/// Caches settings locally for async-less read, and allows settings to be
/// changed. Notifies listeners of any changes.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;

  late ThemeMode _themeMode;
  late AppLanguagePreference _appLanguage;
  late NameVisualizationPreference _nameVisualization;
  late NameFormatPreference _nameFormat;

  /// Returns the user's preferred [ThemeMode].
  ThemeMode get themeMode => _themeMode;

  /// Returns the user's preferred language for the application.
  AppLanguagePreference get appLanguage => _appLanguage;

  /// Returns the user's preferred visualisation for name frequency.
  NameVisualizationPreference get nameVisualization => _nameVisualization;

  /// Returns the user's preferred format for names (kana, romaji)
  NameFormatPreference get nameFormat => _nameFormat;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _appLanguage = await _settingsService.appLanguage();
    _nameVisualization = await _settingsService.nameVisualization();
    _nameFormat = await _settingsService.nameFormat();

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

  Future<void> updateNameVisualization(
      NameVisualizationPreference? nameVisualization) async {
    if (nameVisualization == null) return;
    if (nameVisualization == _nameVisualization) return;

    _nameVisualization = nameVisualization;
    notifyListeners();
    await _settingsService.updateNameVisualization(nameVisualization);
  }

  Future<void> updateNameFormat(NameFormatPreference? nameFormat) async {
    if (nameFormat == null) return;
    if (nameFormat == _nameFormat) return;

    _nameFormat = nameFormat;
    notifyListeners();
    await _settingsService.updateNameFormat(nameFormat);
  }

  /// Returns the application's locale based on the settings. This allows the
  /// user to force a specific locale just for this app.
  Locale? appLocale() {
    switch (appLanguage) {
      // TODO(rjh) this forces en-US?
      case AppLanguagePreference.en:
        return const Locale('en', null);
      case AppLanguagePreference.ja:
        return const Locale('ja', 'JP');
      case AppLanguagePreference.system:
        return null;
    }
  }
}
