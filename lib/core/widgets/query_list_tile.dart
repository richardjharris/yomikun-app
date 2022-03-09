import 'package:flutter/material.dart';
import 'package:yomikun/fixed_result/fixed_result_page.dart';
import 'package:yomikun/search/models/query.dart';
import 'package:yomikun/search/widgets/search_box.dart';

/// ListTile that displays a Query object, for use in bookmarks
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
    Brightness brightness = Theme.of(context).brightness;
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
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: queryModeToColor(query.mode, brightness),
        ),
        child: Center(
            child: Text(queryModeToIcon(query.mode),
                style: style.copyWith(color: Colors.white),
                locale: const Locale('ja'))),
      ),
      title: Text(
        query.text,
        style: style,
      ),
    );
  }
}
