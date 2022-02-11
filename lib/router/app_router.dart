import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yomikun/history/history_page.dart';
import 'package:yomikun/router/open_search_page.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/search/search_page.dart';
import 'package:yomikun/bookmarks/bookmarks_page.dart';
import 'package:yomikun/fixed_result/fixed_result_page.dart';
//import 'package:yomikun/history/history_page.dart';
import 'package:yomikun/settings/settings_page.dart';

class AppRoutes {
  static const homePage = '/';
  static const bookmarksPage = '/bookmarks';
  static const makotoPage = '/makoto';
  static const makotoFixedPage = '/makoto-fixed';
  static const resultPage = '/result-page';
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
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.homePage:
        return const SearchPage();
      case AppRoutes.bookmarksPage:
        return const BookmarksPage();
      case HistoryPage.routeName:
        return const HistoryPage();
      case AppRoutes.makotoFixedPage:
        return const FixedResultPage(query: makotoQuery);
      case SettingsPage.routeName:
        return const SettingsPage();
      case AppRoutes.makotoPage:
        openSearchPage(context, ref, makotoQuery);
        return null;
      case AppRoutes.resultPage:
        final mapArgs = args as Map<String, dynamic>;
        final query = Query.fromMap(mapArgs);
        openSearchPage(context, ref, query);
        return null;
      default:
        assert(false, "Unknown route: ${settings.name}");
        return null;
    }
  }
}
