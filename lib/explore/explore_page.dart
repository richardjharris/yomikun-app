import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yomikun/core/widgets/placeholder_message.dart';
import 'package:yomikun/localization/app_localizations_context.dart';

/// View top 10 most popular names, etc.
class ExplorePage extends ConsumerWidget {
  const ExplorePage({Key? key}) : super(key: key);

  static const String routeName = '/explore';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.explore),
      ),
      body: const PlaceholderMessage('Todo'),
    );
  }
}
