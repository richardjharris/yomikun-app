import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yomikun/app/settings/settings_controller.dart';
import 'package:yomikun/app/settings/settings_service.dart';
import 'package:yomikun/core/provider_logger.dart';
import 'package:yomikun/models/bookmark.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:yomikun/routing/app_router.dart';
import 'package:yomikun/services/bookmark_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yomikun/localization/app_localizations_context.dart';

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
    // TODO use .select()
    final settingsController = ref.watch(settingsControllerProvider);

    return MaterialApp(
      restorationScopeId: 'app',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: settingsController.appLocale(),
      onGenerateTitle: (context) => context.loc.appTitle,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: settingsController.themeMode,
      onGenerateRoute: (settings) =>
          AppRouter.onGenerateRoute(context, ref, settings),
    );
  }
}
