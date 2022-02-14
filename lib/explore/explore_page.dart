import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yomikun/navigation/navigation_drawer.dart';
import 'package:yomikun/core/widgets/placeholder_message.dart';
import 'package:yomikun/localization/app_localizations_context.dart';

class ExplorePageEntry {
  final String title;
  final String? subtitle;
  final String route;
  final Widget? icon;

  const ExplorePageEntry({
    required this.title,
    this.subtitle,
    required this.route,
    this.icon,
  });
}

class _TextIcon extends StatelessWidget {
  final String text;

  const _TextIcon(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: IconTheme.of(context).color,
        ),
      ),
    );
  }
}

/// Displays a list of articles or name listings that might be interesting to
/// the user, such as the most common names or kanji.
class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  static const String routeName = '/explore';

  final List<ExplorePageEntry> pages = const [
    ExplorePageEntry(
      title: 'Most common family names',
      route: '/explore/most-common-family-names',
      icon: Icon(Icons.groups),
    ),
    ExplorePageEntry(
      title: 'Most common given names',
      route: '/explore/most-common-given-names',
      icon: Icon(Icons.person),
    ),
    ExplorePageEntry(
      title: 'Most common kanji',
      route: '/explore/most-common-kanji',
      icon: _TextIcon('漢'),
    ),
    ExplorePageEntry(
      title: 'Unisex names',
      subtitle: 'Names that are commonly used by all genders',
      route: '/explore/unisex-names',
      icon: Icon(Icons.adjust),
    ),
    ExplorePageEntry(
      title: 'Kanji and gender',
      subtitle: 'Graph of the most common kanji used by women or men.',
      route: '/explore/kanji-and-gender',
      icon: Icon(Icons.apps),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: Text(context.loc.explore),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: pages.map((page) {
            return Card(
              child: ListTile(
                title: Text(page.title),
                subtitle: page.subtitle != null ? Text(page.subtitle!) : null,
                onTap: () {
                  Navigator.of(context).pushNamed(page.route);
                },
                leading: page.icon != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [page.icon!],
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
