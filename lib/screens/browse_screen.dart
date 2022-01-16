import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:yomikun/screens/common/name_row.dart';
import 'package:yomikun/models/namedata.dart';

/// Screen for browsing names using wildcards.
class BrowseScreen extends StatelessWidget {
  const BrowseScreen({
    Key? key,
    required this.results,
  }) : super(key: key);

  final List<NameData> results;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const ListTile(
        title: Text('No results found'),
        subtitle: Text("No results were found for the selected search term."),
      );
    }

    return SlidableAutoCloseBehavior(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.5),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        itemCount: (results.length * 2) - 1,
        // Returns a divider between entries (to visually separate them)
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2; // divide by two, round down
          final data = results[index];
          var item = NameRow(nameData: data, key: data.key());

          return Slidable(
            key: ValueKey(data.key()),
            child: item,
            groupTag: results,
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  flex: 1,
                  backgroundColor: Colors.blue.shade900,
                  foregroundColor: Colors.white,
                  onPressed: (context) {
                    // ...
                  },
                  icon: Icons.favorite,
                  label: 'Bookmark',
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}
