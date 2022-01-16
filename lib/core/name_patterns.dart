class NamePatterns {
  static var seiChars = r'\p{Script=Han}ケヶヵノツ';
  static var seiWithKana =
      r'(?:\p{Script=Han}+[ツノ]\p{Script=Han}+|茂り松|下り|走り|渡り|回り道|広エ|新タ|見ル野|反リ目|反り目|安カ川)';

  /// Pattern for a kanji surname, permitting kana in limited circumstances
  static RegExp seiPat =
      RegExp(r'^(?:[' + seiChars + r']+|' + seiWithKana + r')$', unicode: true);

  /// Pattern for a kanji given name
  static RegExp meiPat = RegExp(
      r'^[' + seiChars + r'\p{Script=Hiragana}\p{Script=Katakana}ー]+$',
      unicode: true);

  /// Pattern for a name reading
  static RegExp readingPat =
      RegExp(r'^[ー\p{Script=Hiragana}]+$', unicode: true);
}
