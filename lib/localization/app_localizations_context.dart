import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);

  bool get isJapanese {
    final lang = Localizations.maybeLocaleOf(this)?.toLanguageTag();
    return lang == 'ja';
  }
}
