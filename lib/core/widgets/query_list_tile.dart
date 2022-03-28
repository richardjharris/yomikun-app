import 'package:flutter/material.dart';
import 'package:yomikun/core/widgets/name_icons.dart';
import 'package:yomikun/fixed_result/fixed_result_page.dart';
import 'package:yomikun/search/models/query.dart';

/// ListTile that displays a [Query] object, for use in bookmarks
/// and history.
class QueryListTile extends StatelessWidget {
  final Query query;
  final bool isDeleted;

  const QueryListTile({
    Key? key,
    required this.query,
    this.isDeleted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(fontSize: 20);
    if (isDeleted) {
      style = style.copyWith(
        decoration: TextDecoration.lineThrough,
        color: Colors.grey,
      );
    }

    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, FixedResultPage.routeName,
            arguments: query.toMap());
      },
      leading: QueryModeIcon(query.mode),
      title: Text(query.text, style: style),
    );
  }
}
