import 'package:flutter/material.dart';
import 'package:yomikun/app/bookmarks/bookmarks_page.dart';
import 'package:yomikun/app/fixed_result/fixed_result_page.dart';
import 'package:yomikun/models/query.dart';

class AppRoutes {
  static const bookmarksPage = '/bookmarks';
  static const makotoPage = '/makoto';
  static const resultPage = '/result-page';
}

class AppRouter {
  static const Query makotoQuery = Query.mei('まこと');

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.bookmarksPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const BookmarksPage(),
          settings: settings,
        );
      case AppRoutes.makotoPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const FixedResultPage(query: makotoQuery),
          settings: settings,
        );
      case AppRoutes.resultPage:
        final mapArgs = args as Map<String, dynamic>;
        final query = Query.fromMap(mapArgs);
        return MaterialPageRoute<dynamic>(
          builder: (_) => FixedResultPage(
            query: query,
          ),
          settings: settings,
        );
      default:
        assert(false, "Unknown route: ${settings.name}");
        return null;
    }
  }
}
