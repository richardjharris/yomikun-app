import 'package:flutter/material.dart';
import 'package:yomikun/core/widgets/error_box.dart';
import 'package:yomikun/core/widgets/placeholder_message.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/name_breakdown/name_breakdown_page.dart';
import 'package:yomikun/name_list/name_list_page.dart';
import 'package:yomikun/name_person/name_person_page.dart';
import 'package:yomikun/search/models.dart';

/// Displays the result of a query.
class SearchResults extends StatelessWidget {
  const SearchResults({
    Key? key,
    required this.result,
  }) : super(key: key);

  final QueryResult result;

  @override
  Widget build(BuildContext context) {
    if (result.text.isEmpty) {
      return PlaceholderMessage(context.loc.enterNameInKanjiOrKana);
    }

    switch (result.mode) {
      case QueryMode.mei:
      case QueryMode.sei:
        return NameBreakdownPage(query: result);
      case QueryMode.wildcard:
        return NameListPage(results: result.results.toList());
      case QueryMode.person:
        return NamePersonPage(query: result);
      default:
        return ErrorBox("Unknown mode '${result.mode}'");
    }
  }
}
