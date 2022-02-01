import 'dart:io';

import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yomikun/app/search/search_page.dart';
import 'package:yomikun/core/provider_logger.dart';
import 'package:yomikun/models/bookmark.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:yomikun/providers/core_providers.dart';
import 'package:yomikun/routing/app_router.dart';
import 'package:yomikun/services/bookmark_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yomikun/services/shared_preferences_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(BookmarkAdapter());
  await Hive.openBox<Bookmark>(BookmarkDatabase.hiveBox);

  final sharedPreferences = await SharedPreferences.getInstance();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(ProviderScope(observers: [
    ProviderLogger()
  ], overrides: [
    sharedPreferencesServiceProvider.overrideWithValue(
      SharedPreferencesService(sharedPreferences),
    ),
  ], child: EasyDynamicThemeWidget(child: const MyApp())));
}

/// App entry point
class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: EasyDynamicTheme.of(context).themeMode,
      home: const SearchPage(),
      onGenerateRoute: (settings) =>
          AppRouter.onGenerateRoute(context, ref, settings),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
    );
  }
}
