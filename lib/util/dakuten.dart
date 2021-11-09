import "package:unorm_dart/unorm_dart.dart" as unorm;

/// Expand dakuten and handakuten into their own characters to make them easier
/// to see, using Unicode denormalization.
/// Example: こうざき -> こうさﾞき
String expandDakuten(String input) {
  return unorm
      .nfkd(input)
      .replaceAll(RegExp(r'\u{3099}', unicode: true), r'ﾞ')
      .replaceAll(RegExp(r'\u{309A}', unicode: true), r'ﾟ');
}
