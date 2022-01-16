import 'dart:io';

import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yomikun/screens/bookmarks/bookmarks_screen.dart';
import 'package:yomikun/screens/search/search_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const favoritesBox = 'favorite_names';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<String>(favoritesBox);
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(ProviderScope(child: EasyDynamicThemeWidget(child: const MyApp())));
}

/// App entry point
class MyApp extends StatelessWidget {
  final String title = 'Yomikun';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      title: title,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: EasyDynamicTheme.of(context).themeMode,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SearchScreen(),
        '/bookmarks': (context) => const BookmarksScreen(),
      },
    );
  }
}
