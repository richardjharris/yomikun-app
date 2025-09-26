// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'よみくん';

  @override
  String get debugBanner => 'デバッグ';

  @override
  String get noNameResultsFound => '検索条件に一致する結果が見つかりません。';

  @override
  String get enterNameInKanjiOrKana => '漢字もしくは読みで名前を入力してください';

  @override
  String get changeQueryModeTooltip => '検索モードを変える';

  @override
  String get nameRowM => '男';

  @override
  String get nameRowF => '女';

  @override
  String get nameRowU => '他';

  @override
  String get nameRowFict => '架空';

  @override
  String get error => 'エラー';

  @override
  String get search => '検索';

  @override
  String get bookmarks => 'しおり';

  @override
  String get history => '履歴';

  @override
  String get explore => '資料等';

  @override
  String get quiz => 'クイズ';

  @override
  String get settings => '設定';

  @override
  String get ocrPageTitle => 'カメラで読み取る';

  @override
  String get about => 'このアプリについて';

  @override
  String get theme => 'テーマ';

  @override
  String get systemTheme => 'システム';

  @override
  String get lightTheme => 'ライト';

  @override
  String get darkTheme => 'ダーク';

  @override
  String get appLanguage => 'アプリ言語';

  @override
  String get englishLanguage => '英語';

  @override
  String get japaneseLanguage => '日本語';

  @override
  String get systemLanguage => 'システム';

  @override
  String get settingsTooltip => '設定を開く';

  @override
  String get settingsChangedNameFormatToHiragana => '読みの表示が「ひらがな」に変わりました。';

  @override
  String get nameVisualization => '名前の頻度を表すグラフ';

  @override
  String get nameVizTreeMap => '箱グラフ';

  @override
  String get nameVizPieChart => '円グラフ';

  @override
  String get nameVizNone => '無表示';

  @override
  String get nameDisplayFormat => '名前の読みの表示';

  @override
  String get nameDisplayRomaji => 'ローマ字';

  @override
  String get nameDisplayHiragana => 'ひらがな';

  @override
  String get nameDisplayHiraganaBigAccent => 'ひらがな (半・濁点を強調)';

  @override
  String get clearAllHistory => '履歴を消去する';

  @override
  String get clearAllHistoryConfirm => '履歴を全部消去しますか？';

  @override
  String get thisCannotBeUndone => '元に戻すことはできません。';

  @override
  String get clearAllHistoryConfirmAction => '消去';

  @override
  String get cancelAction => 'キャンセル';

  @override
  String get shareAction => '共有';

  @override
  String get shareTooltip => '共有する';

  @override
  String get noBookmarksMessage =>
      'しおりがありません。しおりを作るには、名前の行を左にスライドして「しおり」を押します。';

  @override
  String get addBookmarkAction => 'しおり';

  @override
  String get removeBookmarkAction => '消去';

  @override
  String get addBookmarkTooltip => 'しおりを追加する';

  @override
  String get removeBookmarkTooltip => 'しおりを消去する';

  @override
  String get sbBookmarkAdded => 'しおりを追加しました';

  @override
  String get sbBookmarkRemoved => 'しおりを消去しました';

  @override
  String get noHistoryMessage => '閲覧履歴がここに表示されます。';

  @override
  String get allPossibleReadings => '全ての読み';

  @override
  String get surname => '姓';

  @override
  String get givenName => '名';

  @override
  String get femaleGender => '女性';

  @override
  String get maleGender => '男性';

  @override
  String get allGenders => 'すべて';

  @override
  String get ocrNoCameraDetected => 'カメラが見つかりません。';

  @override
  String get ocrFromGallery => 'ギャラリーから';

  @override
  String get ocrTakePicture => 'Take a picture';

  @override
  String get goBack => '戻る';

  @override
  String get exMostCommonFamilyNames => '名字のランキング';

  @override
  String get exMostCommonGivenNames => '下の名前のランキング';

  @override
  String get exMostCommonGivenNamesNote =>
      '蓄積されたデータの偏りによって、平均的に男性名の比率が女性名より高いことにご留意ください。';

  @override
  String get exMostCommonKanji => '名前に使われる漢字のランキング';

  @override
  String get exUnisexNames => '中性的な名前';

  @override
  String get exUnisexNamesNote => '男性名にも女性名にも使われる名前のリスト';

  @override
  String get exKanjiAndGender => '漢字と性別';

  @override
  String get exKanjiAndGenderNote => '男性っぽい漢字と女性っぽい漢字';

  @override
  String get exKanjiAndGenderDescription =>
      'この図は、女性名に使われる字をピンク色に、男性名に使われる字を青色にして、社会的な漢字と性別の関係を示しています。';

  @override
  String get exKanjiAndGenderMinHits => '最低ヒット：';

  @override
  String get exViewModeExact => '漢字と読み';

  @override
  String get exViewModeKanji => '漢字';

  @override
  String get exViewModeKana => '読み';

  @override
  String get orderBy => '並べ替え：';

  @override
  String get orderByNameLocaleSpecific => '五十音順';

  @override
  String get orderByPopularity => 'ありふれた名前順';

  @override
  String get orderByNeutrality => '中性順';

  @override
  String get aboutAuthors => 'よみくん開発部';

  @override
  String aboutDevCredit(String appDeveloperEmail) {
    return '開発者：リチャード・ハリス (Richard HARRIS, $appDeveloperEmail)。ご意見やお気づきの点がありましたら、そのメールアドレスまでお願いいたします。';
  }

  @override
  String aboutPhotoCredit(
      String aboutMiyajimaIslandPhoto, String aboutCCBySA2) {
    return '$aboutMiyajimaIslandPhotoはDumphasizerというFlickrのユーザーの写真であり、$aboutCCBySA2の提供で利用いたしました。';
  }

  @override
  String get aboutMiyajimaIslandPhoto => '宮島の写真';

  @override
  String get aboutCCBySA2 => 'CC BY-SA 2.0';

  @override
  String get npTotalHits => '総人数';

  @override
  String get npFictionalHits => '架空・偽名の人数';

  @override
  String get npMale => '男性';

  @override
  String get npFemale => '女性';

  @override
  String get npUnknown => '性別不明';

  @override
  String get npSeeNamesWithSameKanji => '同じ書きの人名を見る';

  @override
  String get npSeeNamesWithSameReading => '同じ読みの人名を見る';

  @override
  String get npNoResultFound => '名前は見つかりませんでした。';

  @override
  String get qzStart => 'スタート';

  @override
  String get qzQuestion => '質問';

  @override
  String get qzAnswer => '答え';

  @override
  String get qzYourScore => '結果';

  @override
  String get qzClearAnswerAction => '削除';

  @override
  String get qzSkipQuestionAction => 'スキップ';

  @override
  String get qzSubmitAnswerAction => '返答';

  @override
  String get qzShowQuizResults => '結果を見る';

  @override
  String get qzNextQuestionAction => '次へ';

  @override
  String get qzSummaryNewQuizAction => 'もう一回';

  @override
  String get qzSummaryQuitAction => 'やめる';

  @override
  String get qzTooltipNewQuiz => 'クイズを作り直す';

  @override
  String get qzStartNewQuizButton => 'スタート';

  @override
  String get qzChangeQuizSettings => '設定';

  @override
  String get qzGivenNames => '下の名前';

  @override
  String get qzFamilyNames => '名字';

  @override
  String get qzAllNames => 'すべて';

  @override
  String get qzQuestionCountLabel => '質問の数';

  @override
  String get qzDifficultyLabel => '難易度';

  @override
  String get qzNameTypeLabel => 'タイプ';

  @override
  String get qzDoneChangingSettingsButton => '終了';

  @override
  String get qzEnterAnswer => '答えを入力してください';

  @override
  String get qzNoAnswer => '(スキップ)';
}
