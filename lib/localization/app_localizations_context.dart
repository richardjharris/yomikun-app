import 'package:flutter/widgets.dart';
import 'package:yomikun/localization/app_localizations.dart';

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);

  bool get isJapanese {
    final lang = Localizations.maybeLocaleOf(this)?.toLanguageTag();
    return lang == 'ja';
  }
}
