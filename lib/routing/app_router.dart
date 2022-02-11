import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yomikun/app/bookmarks/bookmarks_page.dart';
import 'package:yomikun/app/fixed_result/fixed_result_page.dart';
import 'package:yomikun/app/search/search_page.dart';
import 'package:yomikun/app/settings/settings_view.dart';
import 'package:yomikun/models/query.dart';
import 'package:yomikun/routing/open_search_page.dart';

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
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.homePage:
        return MaterialPageRoute(
            builder: (_) => const SearchPage(), settings: settings);
      case AppRoutes.bookmarksPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const BookmarksPage(),
          settings: settings,
        );
      case AppRoutes.makotoPage:
        openSearchPage(context, ref, makotoQuery);
        return null;
      case AppRoutes.makotoFixedPage:
        return MaterialPageRoute(
            builder: (_) => const FixedResultPage(query: makotoQuery),
            settings: settings);
      case AppRoutes.resultPage:
        final mapArgs = args as Map<String, dynamic>;
        final query = Query.fromMap(mapArgs);
        openSearchPage(context, ref, query);
        return null;
      case SettingsView.routeName:
        return MaterialPageRoute(
            builder: (_) => const SettingsView(), settings: settings);
      default:
        assert(false, "Unknown route: ${settings.name}");
        return null;
    }
  }
}
