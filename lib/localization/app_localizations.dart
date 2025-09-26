import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Yomikun'**
  String get appTitle;

  /// No description provided for @debugBanner.
  ///
  /// In en, this message translates to:
  /// **'DEBUG'**
  String get debugBanner;

  /// Message shown when user has queried for a name but no results were found.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noNameResultsFound;

  /// No description provided for @enterNameInKanjiOrKana.
  ///
  /// In en, this message translates to:
  /// **'Enter a name in kanji or kana'**
  String get enterNameInKanjiOrKana;

  /// No description provided for @changeQueryModeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Change query mode'**
  String get changeQueryModeTooltip;

  /// Short (1 letter/char) label before male hit count in name data rows
  ///
  /// In en, this message translates to:
  /// **'M:'**
  String get nameRowM;

  /// No description provided for @nameRowF.
  ///
  /// In en, this message translates to:
  /// **'F:'**
  String get nameRowF;

  /// No description provided for @nameRowU.
  ///
  /// In en, this message translates to:
  /// **'U:'**
  String get nameRowU;

  /// No description provided for @nameRowFict.
  ///
  /// In en, this message translates to:
  /// **'Fict:'**
  String get nameRowFict;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @quiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quiz;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Name for OCR page in navigation drawer
  ///
  /// In en, this message translates to:
  /// **'Camera OCR'**
  String get ocrPageTitle;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About this app'**
  String get about;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'Application language'**
  String get appLanguage;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @japaneseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get japaneseLanguage;

  /// Option shown to denote using the system locale (language)
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemLanguage;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Change settings'**
  String get settingsTooltip;

  /// This snackbar is displayed when changing the language from English to Japanese, and the name format is implicitly changed from romaji to hiragana. It should always be in Japanese.
  ///
  /// In en, this message translates to:
  /// **'読みの表示が「ひらがな」に変わりました。'**
  String get settingsChangedNameFormatToHiragana;

  /// No description provided for @nameVisualization.
  ///
  /// In en, this message translates to:
  /// **'Name frequency visual'**
  String get nameVisualization;

  /// No description provided for @nameVizTreeMap.
  ///
  /// In en, this message translates to:
  /// **'Boxes'**
  String get nameVizTreeMap;

  /// No description provided for @nameVizPieChart.
  ///
  /// In en, this message translates to:
  /// **'Pie chart'**
  String get nameVizPieChart;

  /// No description provided for @nameVizNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get nameVizNone;

  /// No description provided for @nameDisplayFormat.
  ///
  /// In en, this message translates to:
  /// **'Name display format'**
  String get nameDisplayFormat;

  /// No description provided for @nameDisplayRomaji.
  ///
  /// In en, this message translates to:
  /// **'Romaji'**
  String get nameDisplayRomaji;

  /// No description provided for @nameDisplayHiragana.
  ///
  /// In en, this message translates to:
  /// **'Hiragana'**
  String get nameDisplayHiragana;

  /// No description provided for @nameDisplayHiraganaBigAccent.
  ///
  /// In en, this message translates to:
  /// **'Hiragana (larger accents)'**
  String get nameDisplayHiraganaBigAccent;

  /// No description provided for @clearAllHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get clearAllHistory;

  /// No description provided for @clearAllHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Really delete all history?'**
  String get clearAllHistoryConfirm;

  /// No description provided for @thisCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get thisCannotBeUndone;

  /// No description provided for @clearAllHistoryConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get clearAllHistoryConfirmAction;

  /// No description provided for @cancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// No description provided for @shareAction.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareAction;

  /// No description provided for @shareTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareTooltip;

  /// No description provided for @noBookmarksMessage.
  ///
  /// In en, this message translates to:
  /// **'You have no bookmarks. To bookmark a name, slide it to the left and select \"Bookmark\"'**
  String get noBookmarksMessage;

  /// No description provided for @addBookmarkAction.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get addBookmarkAction;

  /// No description provided for @removeBookmarkAction.
  ///
  /// In en, this message translates to:
  /// **'Unbookmark'**
  String get removeBookmarkAction;

  /// No description provided for @addBookmarkTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add bookmark'**
  String get addBookmarkTooltip;

  /// No description provided for @removeBookmarkTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get removeBookmarkTooltip;

  /// No description provided for @sbBookmarkAdded.
  ///
  /// In en, this message translates to:
  /// **'Bookmark added'**
  String get sbBookmarkAdded;

  /// No description provided for @sbBookmarkRemoved.
  ///
  /// In en, this message translates to:
  /// **'Bookmark removed'**
  String get sbBookmarkRemoved;

  /// No description provided for @noHistoryMessage.
  ///
  /// In en, this message translates to:
  /// **'No history to display.'**
  String get noHistoryMessage;

  /// No description provided for @allPossibleReadings.
  ///
  /// In en, this message translates to:
  /// **'All possible readings:'**
  String get allPossibleReadings;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @givenName.
  ///
  /// In en, this message translates to:
  /// **'Given name'**
  String get givenName;

  /// No description provided for @femaleGender.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get femaleGender;

  /// No description provided for @maleGender.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get maleGender;

  /// No description provided for @allGenders.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allGenders;

  /// No description provided for @ocrNoCameraDetected.
  ///
  /// In en, this message translates to:
  /// **'No camera detected.'**
  String get ocrNoCameraDetected;

  /// No description provided for @ocrFromGallery.
  ///
  /// In en, this message translates to:
  /// **'From camera gallery'**
  String get ocrFromGallery;

  /// No description provided for @ocrTakePicture.
  ///
  /// In en, this message translates to:
  /// **'Take a picture'**
  String get ocrTakePicture;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @exMostCommonFamilyNames.
  ///
  /// In en, this message translates to:
  /// **'Most common family names'**
  String get exMostCommonFamilyNames;

  /// No description provided for @exMostCommonGivenNames.
  ///
  /// In en, this message translates to:
  /// **'Most common given names'**
  String get exMostCommonGivenNames;

  /// No description provided for @exMostCommonGivenNamesNote.
  ///
  /// In en, this message translates to:
  /// **'Note: The dataset is male-biased, so male names currently dominate the ranking.'**
  String get exMostCommonGivenNamesNote;

  /// No description provided for @exMostCommonKanji.
  ///
  /// In en, this message translates to:
  /// **'Most common kanji'**
  String get exMostCommonKanji;

  /// No description provided for @exUnisexNames.
  ///
  /// In en, this message translates to:
  /// **'Unisex names'**
  String get exUnisexNames;

  /// No description provided for @exUnisexNamesNote.
  ///
  /// In en, this message translates to:
  /// **'Names that are commonly used by all genders'**
  String get exUnisexNamesNote;

  /// No description provided for @exKanjiAndGender.
  ///
  /// In en, this message translates to:
  /// **'Kanji and gender'**
  String get exKanjiAndGender;

  /// No description provided for @exKanjiAndGenderNote.
  ///
  /// In en, this message translates to:
  /// **'Visualisation of the most common kanji used by women or men.'**
  String get exKanjiAndGenderNote;

  /// No description provided for @exKanjiAndGenderDescription.
  ///
  /// In en, this message translates to:
  /// **'This is a map of kanji most associated with men (blue) or women (pink) based on aggregate name data.'**
  String get exKanjiAndGenderDescription;

  /// No description provided for @exKanjiAndGenderMinHits.
  ///
  /// In en, this message translates to:
  /// **'Minimum hits:'**
  String get exKanjiAndGenderMinHits;

  /// No description provided for @exViewModeExact.
  ///
  /// In en, this message translates to:
  /// **'Exact'**
  String get exViewModeExact;

  /// No description provided for @exViewModeKanji.
  ///
  /// In en, this message translates to:
  /// **'Kanji'**
  String get exViewModeKanji;

  /// No description provided for @exViewModeKana.
  ///
  /// In en, this message translates to:
  /// **'Kana'**
  String get exViewModeKana;

  /// Label shown before a dropdown of ordering options
  ///
  /// In en, this message translates to:
  /// **'Order by:'**
  String get orderBy;

  /// Label for ordering by name (alphabetical for non-Japanese locales; gojuon for Japanese locales)
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get orderByNameLocaleSpecific;

  /// No description provided for @orderByPopularity.
  ///
  /// In en, this message translates to:
  /// **'Popularity'**
  String get orderByPopularity;

  /// Label for ordering most gender-neutral names first, i.e. those with similar male and female hit counts
  ///
  /// In en, this message translates to:
  /// **'Neutrality'**
  String get orderByNeutrality;

  /// No description provided for @aboutAuthors.
  ///
  /// In en, this message translates to:
  /// **'Yomikun Developers'**
  String get aboutAuthors;

  /// No description provided for @aboutDevCredit.
  ///
  /// In en, this message translates to:
  /// **'This app was created by Richard Harris ({appDeveloperEmail}). Please contact me if you have any issues or feature requests.'**
  String aboutDevCredit(String appDeveloperEmail);

  /// No description provided for @aboutPhotoCredit.
  ///
  /// In en, this message translates to:
  /// **'{aboutMiyajimaIslandPhoto} credited to Flickr user Dumphasizer, used under the {aboutCCBySA2} license.'**
  String aboutPhotoCredit(String aboutMiyajimaIslandPhoto, String aboutCCBySA2);

  /// No description provided for @aboutMiyajimaIslandPhoto.
  ///
  /// In en, this message translates to:
  /// **'Miyajima Island photo'**
  String get aboutMiyajimaIslandPhoto;

  /// No description provided for @aboutCCBySA2.
  ///
  /// In en, this message translates to:
  /// **'CC BY-SA 2.0'**
  String get aboutCCBySA2;

  /// No description provided for @npTotalHits.
  ///
  /// In en, this message translates to:
  /// **'Total hits'**
  String get npTotalHits;

  /// No description provided for @npFictionalHits.
  ///
  /// In en, this message translates to:
  /// **'Fictional hits'**
  String get npFictionalHits;

  /// No description provided for @npMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get npMale;

  /// No description provided for @npFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get npFemale;

  /// No description provided for @npUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get npUnknown;

  /// No description provided for @npSeeNamesWithSameKanji.
  ///
  /// In en, this message translates to:
  /// **'See names with the same kanji'**
  String get npSeeNamesWithSameKanji;

  /// No description provided for @npSeeNamesWithSameReading.
  ///
  /// In en, this message translates to:
  /// **'See names with the same reading'**
  String get npSeeNamesWithSameReading;

  /// No description provided for @npNoResultFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get npNoResultFound;

  /// No description provided for @qzStart.
  ///
  /// In en, this message translates to:
  /// **'Start Quiz'**
  String get qzStart;

  /// No description provided for @qzQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get qzQuestion;

  /// No description provided for @qzAnswer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get qzAnswer;

  /// No description provided for @qzYourScore.
  ///
  /// In en, this message translates to:
  /// **'Your score'**
  String get qzYourScore;

  /// No description provided for @qzClearAnswerAction.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get qzClearAnswerAction;

  /// No description provided for @qzSkipQuestionAction.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get qzSkipQuestionAction;

  /// No description provided for @qzSubmitAnswerAction.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get qzSubmitAnswerAction;

  /// No description provided for @qzShowQuizResults.
  ///
  /// In en, this message translates to:
  /// **'Show results'**
  String get qzShowQuizResults;

  /// No description provided for @qzNextQuestionAction.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get qzNextQuestionAction;

  /// No description provided for @qzSummaryNewQuizAction.
  ///
  /// In en, this message translates to:
  /// **'New quiz'**
  String get qzSummaryNewQuizAction;

  /// No description provided for @qzSummaryQuitAction.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get qzSummaryQuitAction;

  /// No description provided for @qzTooltipNewQuiz.
  ///
  /// In en, this message translates to:
  /// **'New quiz'**
  String get qzTooltipNewQuiz;

  /// No description provided for @qzStartNewQuizButton.
  ///
  /// In en, this message translates to:
  /// **'Start New Quiz'**
  String get qzStartNewQuizButton;

  /// No description provided for @qzChangeQuizSettings.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get qzChangeQuizSettings;

  /// No description provided for @qzGivenNames.
  ///
  /// In en, this message translates to:
  /// **'Given names'**
  String get qzGivenNames;

  /// No description provided for @qzFamilyNames.
  ///
  /// In en, this message translates to:
  /// **'Family names'**
  String get qzFamilyNames;

  /// No description provided for @qzAllNames.
  ///
  /// In en, this message translates to:
  /// **'All names'**
  String get qzAllNames;

  /// No description provided for @qzQuestionCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get qzQuestionCountLabel;

  /// No description provided for @qzDifficultyLabel.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get qzDifficultyLabel;

  /// No description provided for @qzNameTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get qzNameTypeLabel;

  /// No description provided for @qzDoneChangingSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get qzDoneChangingSettingsButton;

  /// No description provided for @qzEnterAnswer.
  ///
  /// In en, this message translates to:
  /// **'Enter answer'**
  String get qzEnterAnswer;

  /// No description provided for @qzNoAnswer.
  ///
  /// In en, this message translates to:
  /// **'No answer'**
  String get qzNoAnswer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
