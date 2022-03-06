import 'package:flutter/material.dart';
import 'package:yomikun/about/about_dialog.dart';
import 'package:yomikun/bookmarks/bookmarks_page.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/explore/explore_page.dart';
import 'package:yomikun/gen/assets.gen.dart';
import 'package:yomikun/history/history_page.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/ocr/ocr_page.dart';
import 'package:yomikun/settings/settings_page.dart';

/// Slide-out drawer for navigation (bookmarks, history, settings etc.)
class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final splashOpacity =
        Theme.of(context).brightness == Brightness.dark ? 0.8 : 1.0;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text(context.loc.appTitle,
                style: const TextStyle(color: Colors.white, fontSize: 25)),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: Assets.sidemenuSplash,
                  filterQuality: FilterQuality.medium, // no aliasing
                  opacity: splashOpacity),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: Text(context.loc.search),
            onTap: () {
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          ListTile(
            leading: const Icon(Icons.star_border),
            title: Text(context.loc.bookmarks),
            onTap: () {
              Navigator.pop(context);
              Navigator.restorablePushNamed(context, BookmarksPage.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(context.loc.history),
            onTap: () {
              Navigator.pop(context);
              Navigator.restorablePushNamed(context, HistoryPage.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(context.loc.explore),
            onTap: () {
              Navigator.pop(context);
              Navigator.restorablePushNamed(context, ExplorePage.routeName);
            },
          ),
          if (cameras.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(context.loc.ocrPageTitle),
              onTap: () {
                Navigator.pop(context);
                Navigator.restorablePushNamed(context, OcrPage.routeName);
              },
            ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(context.loc.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, SettingsPage.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(context.loc.about),
            onTap: () async {
              await showYomikunAboutDialog(context);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Makoto'),
            onTap: () {
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.restorablePushNamed(context, '/makoto');
            },
          ),
          ListTile(
            title: const Text('Makoto (fixed)'),
            onTap: () {
              Navigator.pop(context);
              Navigator.restorablePushNamed(context, '/makoto-fixed');
            },
          ),
        ],
      ),
    );
  }
}
