import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yomikun/about/about_page.dart';
import 'package:yomikun/explore/explore_page.dart';
import 'package:yomikun/explore/screens/kanji_and_gender_page.dart';
import 'package:yomikun/explore/screens/most_common_names_page.dart';
import 'package:yomikun/history/history_page.dart';
import 'package:yomikun/navigation/open_search_page.dart';
import 'package:yomikun/ocr/ocr_page.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/search/search_page.dart';
import 'package:yomikun/bookmarks/bookmarks_page.dart';
import 'package:yomikun/fixed_result/fixed_result_page.dart';
//import 'package:yomikun/history/history_page.dart';
import 'package:yomikun/settings/settings_page.dart';

class AppRoutes {
  static const makotoPage = '/makoto';
  static const makotoFixedPage = '/makoto-fixed';
  static const search = '/search';
}

class AppRouter {
  static const Query makotoQuery = Query.mei('まこと');

  static Route<dynamic>? onGenerateRoute(
      BuildContext context, WidgetRef ref, RouteSettings settings) {
    dynamic route = _generateRoute(context, ref, settings);
    if (route == null) {
      return null;
    } else if (route is Widget) {
      return MaterialPageRoute(
        builder: (context) => route,
        settings: settings,
      );
    } else {
      return route as Route;
    }
  }

  // Convenience method that can return either a Widget, Route or null.
  static dynamic _generateRoute(
      BuildContext context, WidgetRef ref, RouteSettings settings) {
    var args = (settings.arguments ?? {}) as Map<dynamic, dynamic>;

    // We allow route paths to have query string parameters, which are converted
    // into a Map of arguments.
    final settingsUri = Uri.parse(settings.name!);
    args.addAll(settingsUri.queryParameters);

    switch (settingsUri.path) {
      case SearchPage.routeName:
        return const SearchPage();

      case BookmarksPage.routeName:
        return const BookmarksPage();

      case HistoryPage.routeName:
        return const HistoryPage();

      case ExplorePage.routeName:
        return const ExplorePage();

      case OcrPage.routeName:
        return OcrPage();

      case AppRoutes.makotoFixedPage:
        return const FixedResultPage(query: makotoQuery);

      case SettingsPage.routeName:
        return const SettingsPage();

      case AboutPage.routeName:
        return const AboutPage();

      case AppRoutes.makotoPage:
        openSearchPage(context, ref, makotoQuery);
        return null;

      case FixedResultPage.routeName:
        final query = Query.fromMap(args);
        return FixedResultPage(query: query);

      case AppRoutes.search:
        final query = Query.fromMap(args);
        openSearchPage(context, ref, query);
        return null;

      case MostCommonNamesPage.routeNameFamily:
        return const MostCommonNamesPage(part: NamePart.sei);

      case MostCommonNamesPage.routeNameGiven:
        return const MostCommonNamesPage(part: NamePart.mei);

      case KanjiAndGenderPage.routeName:
        return const KanjiAndGenderPage();

      default:
        assert(false, "Unknown route: ${settings.name}");
        return null;
    }
  }
}
