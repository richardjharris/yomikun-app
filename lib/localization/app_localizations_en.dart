// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Yomikun';

  @override
  String get debugBanner => 'DEBUG';

  @override
  String get noNameResultsFound => 'No results found';

  @override
  String get enterNameInKanjiOrKana => 'Enter a name in kanji or kana';

  @override
  String get changeQueryModeTooltip => 'Change query mode';

  @override
  String get nameRowM => 'M:';

  @override
  String get nameRowF => 'F:';

  @override
  String get nameRowU => 'U:';

  @override
  String get nameRowFict => 'Fict:';

  @override
  String get error => 'Error';

  @override
  String get search => 'Search';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get history => 'History';

  @override
  String get explore => 'Explore';

  @override
  String get quiz => 'Quiz';

  @override
  String get settings => 'Settings';

  @override
  String get ocrPageTitle => 'Camera OCR';

  @override
  String get about => 'About this app';

  @override
  String get theme => 'Theme';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get appLanguage => 'Application language';

  @override
  String get englishLanguage => 'English';

  @override
  String get japaneseLanguage => 'Japanese';

  @override
  String get systemLanguage => 'System';

  @override
  String get settingsTooltip => 'Change settings';

  @override
  String get settingsChangedNameFormatToHiragana => '読みの表示が「ひらがな」に変わりました。';

  @override
  String get nameVisualization => 'Name frequency visual';

  @override
  String get nameVizTreeMap => 'Boxes';

  @override
  String get nameVizPieChart => 'Pie chart';

  @override
  String get nameVizNone => 'None';

  @override
  String get nameDisplayFormat => 'Name display format';

  @override
  String get nameDisplayRomaji => 'Romaji';

  @override
  String get nameDisplayHiragana => 'Hiragana';

  @override
  String get nameDisplayHiraganaBigAccent => 'Hiragana (larger accents)';

  @override
  String get clearAllHistory => 'Clear history';

  @override
  String get clearAllHistoryConfirm => 'Really delete all history?';

  @override
  String get thisCannotBeUndone => 'This action cannot be undone.';

  @override
  String get clearAllHistoryConfirmAction => 'Delete';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get shareAction => 'Share';

  @override
  String get shareTooltip => 'Share';

  @override
  String get noBookmarksMessage =>
      'You have no bookmarks. To bookmark a name, slide it to the left and select \"Bookmark\"';

  @override
  String get addBookmarkAction => 'Bookmark';

  @override
  String get removeBookmarkAction => 'Unbookmark';

  @override
  String get addBookmarkTooltip => 'Add bookmark';

  @override
  String get removeBookmarkTooltip => 'Remove bookmark';

  @override
  String get sbBookmarkAdded => 'Bookmark added';

  @override
  String get sbBookmarkRemoved => 'Bookmark removed';

  @override
  String get noHistoryMessage => 'No history to display.';

  @override
  String get allPossibleReadings => 'All possible readings:';

  @override
  String get surname => 'Surname';

  @override
  String get givenName => 'Given name';

  @override
  String get femaleGender => 'Female';

  @override
  String get maleGender => 'Male';

  @override
  String get allGenders => 'All';

  @override
  String get ocrNoCameraDetected => 'No camera detected.';

  @override
  String get ocrFromGallery => 'From camera gallery';

  @override
  String get ocrTakePicture => 'Take a picture';

  @override
  String get goBack => 'Go back';

  @override
  String get exMostCommonFamilyNames => 'Most common family names';

  @override
  String get exMostCommonGivenNames => 'Most common given names';

  @override
  String get exMostCommonGivenNamesNote =>
      'Note: The dataset is male-biased, so male names currently dominate the ranking.';

  @override
  String get exMostCommonKanji => 'Most common kanji';

  @override
  String get exUnisexNames => 'Unisex names';

  @override
  String get exUnisexNamesNote => 'Names that are commonly used by all genders';

  @override
  String get exKanjiAndGender => 'Kanji and gender';

  @override
  String get exKanjiAndGenderNote =>
      'Visualisation of the most common kanji used by women or men.';

  @override
  String get exKanjiAndGenderDescription =>
      'This is a map of kanji most associated with men (blue) or women (pink) based on aggregate name data.';

  @override
  String get exKanjiAndGenderMinHits => 'Minimum hits:';

  @override
  String get exViewModeExact => 'Exact';

  @override
  String get exViewModeKanji => 'Kanji';

  @override
  String get exViewModeKana => 'Kana';

  @override
  String get orderBy => 'Order by:';

  @override
  String get orderByNameLocaleSpecific => 'Name';

  @override
  String get orderByPopularity => 'Popularity';

  @override
  String get orderByNeutrality => 'Neutrality';

  @override
  String get aboutAuthors => 'Yomikun Developers';

  @override
  String aboutDevCredit(String appDeveloperEmail) {
    return 'This app was created by Richard Harris ($appDeveloperEmail). Please contact me if you have any issues or feature requests.';
  }

  @override
  String aboutPhotoCredit(
      String aboutMiyajimaIslandPhoto, String aboutCCBySA2) {
    return '$aboutMiyajimaIslandPhoto credited to Flickr user Dumphasizer, used under the $aboutCCBySA2 license.';
  }

  @override
  String get aboutMiyajimaIslandPhoto => 'Miyajima Island photo';

  @override
  String get aboutCCBySA2 => 'CC BY-SA 2.0';

  @override
  String get npTotalHits => 'Total hits';

  @override
  String get npFictionalHits => 'Fictional hits';

  @override
  String get npMale => 'Male';

  @override
  String get npFemale => 'Female';

  @override
  String get npUnknown => 'Unknown';

  @override
  String get npSeeNamesWithSameKanji => 'See names with the same kanji';

  @override
  String get npSeeNamesWithSameReading => 'See names with the same reading';

  @override
  String get npNoResultFound => 'No results found';

  @override
  String get qzStart => 'Start Quiz';

  @override
  String get qzQuestion => 'Question';

  @override
  String get qzAnswer => 'Answer';

  @override
  String get qzYourScore => 'Your score';

  @override
  String get qzClearAnswerAction => 'Clear';

  @override
  String get qzSkipQuestionAction => 'Skip';

  @override
  String get qzSubmitAnswerAction => 'Submit';

  @override
  String get qzShowQuizResults => 'Show results';

  @override
  String get qzNextQuestionAction => 'Next';

  @override
  String get qzSummaryNewQuizAction => 'New quiz';

  @override
  String get qzSummaryQuitAction => 'Quit';

  @override
  String get qzTooltipNewQuiz => 'New quiz';

  @override
  String get qzStartNewQuizButton => 'Start New Quiz';

  @override
  String get qzChangeQuizSettings => 'Change';

  @override
  String get qzGivenNames => 'Given names';

  @override
  String get qzFamilyNames => 'Family names';

  @override
  String get qzAllNames => 'All names';

  @override
  String get qzQuestionCountLabel => 'Questions';

  @override
  String get qzDifficultyLabel => 'Difficulty';

  @override
  String get qzNameTypeLabel => 'Type';

  @override
  String get qzDoneChangingSettingsButton => 'Done';

  @override
  String get qzEnterAnswer => 'Enter answer';

  @override
  String get qzNoAnswer => 'No answer';

  @override
  String get qzAbandonQuizTitle => 'Leave quiz?';

  @override
  String get qzAbandonQuizMessage =>
      'Leaving now will abandon your current quiz.';

  @override
  String get qzAbandonQuizConfirm => 'Leave quiz';
}
