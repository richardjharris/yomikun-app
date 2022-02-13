import 'package:flutter/material.dart';
import 'package:yomikun/gen/assets.gen.dart';
import 'package:yomikun/localization/app_localizations_context.dart';

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
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: Text(context.loc.bookmarks),
            onTap: () {
              Navigator.restorablePopAndPushNamed(context, '/bookmarks');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(context.loc.history),
            onTap: () {
              Navigator.restorablePopAndPushNamed(context, '/history');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_backup_restore),
            title: Text(context.loc.explore),
            onTap: () {
              Navigator.restorablePopAndPushNamed(context, '/explore');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(context.loc.settings),
            onTap: () {
              Navigator.restorablePopAndPushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(context.loc.about),
            onTap: () {
              Navigator.restorablePopAndPushNamed(context, '/about');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Makoto'),
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.restorablePushNamed(context, '/makoto');
            },
          ),
          ListTile(
            title: const Text('Makoto (fixed)'),
            onTap: () {
              Navigator.restorablePopAndPushNamed(context, '/makoto-fixed');
            },
          ),
        ],
      ),
    );
  }
}
