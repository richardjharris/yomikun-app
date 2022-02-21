import 'package:flutter/material.dart';
import 'package:yomikun/explore/screens/kanji_and_gender_page.dart';
import 'package:yomikun/explore/screens/most_common_names_page.dart';
import 'package:yomikun/navigation/navigation_drawer.dart';
import 'package:yomikun/localization/app_localizations_context.dart';

/// Displays a list of articles or name listings that might be interesting to
/// the user, such as the most common names or kanji.
class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  static const String routeName = '/explore';

  final List<ExplorePageEntry> pages = const [
    ExplorePageEntry(
      title: 'Most common family names',
      route: MostCommonNamesPage.routeNameFamily,
      icon: Icon(Icons.groups),
    ),
    ExplorePageEntry(
      title: 'Most common given names',
      subtitle:
          'Note: The dataset is quite male-biased, so male names currently dominate the ranking.',
      route: MostCommonNamesPage.routeNameGiven,
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
      route: KanjiAndGenderPage.routeName,
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

/// Renders a small text message in the same dimensions and colour as an [Icon]
/// widget.
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
