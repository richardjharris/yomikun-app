/// User's chosen app language. System defers to the OS.
enum AppLanguagePreference { en, ja, system }

/// User's chosen visualization method for showing the most popular kanji or
/// readings for a name.
enum NameVisualizationPreference { pieChart, treeMap, none }

/// User's chosen display format for names.
enum NameFormatPreference { hiragana, hiraganaBigAccent, romaji }

extension NameFormatPreferenceMethods on NameFormatPreference {
  bool get isRomaji => this == NameFormatPreference.romaji;
}
