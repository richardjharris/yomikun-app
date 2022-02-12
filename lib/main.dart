import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yomikun/bookmarks/models/bookmark.dart';
import 'package:yomikun/core/utilities/provider_logger.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:yomikun/router/app_router.dart';
import 'package:yomikun/bookmarks/services/bookmark_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/settings/settings_controller.dart';
import 'package:yomikun/settings/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(BookmarkAdapter());
  await Hive.openBox<Bookmark>(BookmarkDatabase.hiveBox);

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    ProviderScope(
      observers: [
        ProviderLogger(),
      ],
      overrides: [
        settingsControllerProvider.overrideWithValue(settingsController)
      ],
      child: const MyApp(),
    ),
  );
}

/// App entry point
class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale =
        ref.watch(settingsControllerProvider.select((s) => s.appLocale()));
    final themeMode =
        ref.watch(settingsControllerProvider.select((s) => s.themeMode));

    return MaterialApp(
      restorationScopeId: 'app',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      onGenerateTitle: (context) => context.loc.appTitle,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      onGenerateRoute: (settings) =>
          AppRouter.onGenerateRoute(context, ref, settings),
      initialRoute: '/',
      // Show debug banner in custom position
      builder: (context, child) => Banner(
        message: context.loc.debugBanner,
        textDirection: TextDirection.ltr,
        location: BannerLocation.bottomStart,
        child: child,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
