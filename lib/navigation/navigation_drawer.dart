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
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          ListTile(
            leading: const Icon(Icons.star_border),
            title: Text(context.loc.bookmarks),
            onTap: () {
              Navigator.pop(context);
              Navigator.restorablePushNamed(context, '/bookmarks');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(context.loc.history),
            onTap: () {
              Navigator.pop(context);
              Navigator.restorablePushNamed(context, '/history');
            },
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(context.loc.explore),
            onTap: () {
              Navigator.pop(context);
              Navigator.restorablePushNamed(context, '/explore');
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: Text("Camera OCR"),
            onTap: () {
              Navigator.pop(context);
              Navigator.restorablePushNamed(context, '/ocr');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(context.loc.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(context.loc.about),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/about');
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
