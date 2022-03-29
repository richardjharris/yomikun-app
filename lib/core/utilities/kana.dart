import "package:unorm_dart/unorm_dart.dart" as unorm;
import 'package:yomikun/core/providers/core_providers.dart';

/// Expand dakuten and handakuten into their own characters to make them easier
/// to see, using Unicode denormalization.
/// Example: こうざき -> こうさﾞき
String expandDakuten(String input) {
  return unorm
      .nfkd(input)
      .replaceAll(RegExp(r'\u{3099}', unicode: true), r'ﾞ')
      .replaceAll(RegExp(r'\u{309A}', unicode: true), r'ﾟ');
}

/// Convert a kana string to romaji.
String kanaToRomaji(String kana) {
  return kanaKit.toRomaji(kana);
}

/// Convert a romaji string to kana.
String romajiToKana(String romaji) {
  return kanaKit.toHiragana(romaji);
}
