import 'package:flutter/material.dart';
import 'package:yomikun/explore/screens/kanji_and_gender_page.dart';
import 'package:yomikun/explore/screens/most_common_kanji_page.dart';
import 'package:yomikun/explore/screens/most_common_names_page.dart';
import 'package:yomikun/explore/screens/unisex_names_page.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/navigation/side_navigation_drawer.dart';

/// Displays a list of articles or name listings that might be interesting to
/// the user, such as the most common names or kanji.
class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  static const String routeName = '/explore';

  @override
  Widget build(BuildContext context) {
    final List<ExplorePageEntry> pages = [
      ExplorePageEntry(
        title: context.loc.exMostCommonFamilyNames,
        route: MostCommonNamesPage.routeNameFamily,
        icon: const Icon(Icons.groups),
      ),
      ExplorePageEntry(
        title: context.loc.exMostCommonGivenNames,
        subtitle: context.loc.exMostCommonGivenNamesNote,
        route: MostCommonNamesPage.routeNameGiven,
        icon: const Icon(Icons.person),
      ),
      ExplorePageEntry(
        title: context.loc.exMostCommonKanji,
        route: MostCommonKanjiPage.routeName,
        icon: const _TextIcon('漢'),
      ),
      ExplorePageEntry(
        title: context.loc.exUnisexNames,
        subtitle: context.loc.exUnisexNamesNote,
        route: UnisexNamesPage.routeName,
        icon: const Icon(Icons.adjust),
      ),
      ExplorePageEntry(
        title: context.loc.exKanjiAndGender,
        subtitle: context.loc.exKanjiAndGenderNote,
        route: KanjiAndGenderPage.routeName,
        icon: const Icon(Icons.apps),
      ),
    ];

    return Scaffold(
      drawer: SideNavigationDrawer(),
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
