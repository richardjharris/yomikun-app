import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/core/utilities/number_format.dart';
import 'package:yomikun/core/widgets/basic_name_row.dart';
import 'package:yomikun/core/widgets/button_switch_bar.dart';
import 'package:yomikun/core/widgets/error_box.dart';
import 'package:yomikun/core/widgets/loading_box.dart';
import 'package:yomikun/name_breakdown/name_breakdown_page.dart';
import 'package:yomikun/search/models.dart';
import 'package:collection/collection.dart';
import 'package:yomikun/settings/models/settings_models.dart';
import 'package:yomikun/settings/settings_controller.dart';
import 'package:yomikun/settings/settings_service.dart';

enum SortOrder { popularity, neutrality, name }

final unisexNamesProvider = FutureProvider<List<NameData>>(
    (ref) => ref.read(databaseProvider).getUnisexFirstNames());

final sortedProvider =
    FutureProvider.family<List<NameData>, SortOrder>((ref, sortOrder) async {
  final data = await ref.watch(unisexNamesProvider.future);
  final nameFormat =
      ref.watch(settingsControllerProvider.select((p) => p.nameFormat));

  switch (sortOrder) {
    case SortOrder.popularity:
      // Negate so we sort in reverse.
      return data.sortedBy<num>((n) => -n.hitsTotal);
    case SortOrder.neutrality:
      return data.sortedBy<num>((n) => (127 - n.genderMlScore).abs());
    case SortOrder.name:
      // Sort alphabetically for romaji names, gojuon for kana names.
      switch (nameFormat) {
        case NameFormatPreference.romaji:
          return data.sortedBy((n) => kanaKit.toRomaji(n.yomi));
        case NameFormatPreference.hiragana:
        case NameFormatPreference.hiraganaBigAccent:
          return data.sortedBy((n) => n.yomi);
      }
  }
});

/// Shows unisex names.
class UnisexNamesPage extends HookConsumerWidget {
  const UnisexNamesPage({Key? key}) : super(key: key);

  static const String routeName = '/explore/unisex-names';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortOrder = useState<SortOrder>(SortOrder.popularity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unisex names'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Order by:'),
                const SizedBox(width: 10),
                DropdownButton<SortOrder>(
                  value: sortOrder.value,
                  items: const [
                    DropdownMenuItem(
                      value: SortOrder.popularity,
                      child: Text('Popularity'),
                    ),
                    DropdownMenuItem(
                      value: SortOrder.neutrality,
                      child: Text('Neutrality'),
                    ),
                    DropdownMenuItem(
                      value: SortOrder.name,
                      child: Text('Name'),
                    ),
                  ],
                  onChanged: (value) => sortOrder.value = value!,
                ),
              ],
            ),
            Expanded(
              child: UnisexNamesList(sortOrder: sortOrder.value),
            ),
          ],
        ),
      ),
    );
  }
}

class UnisexNamesList extends ConsumerWidget {
  final SortOrder sortOrder;

  const UnisexNamesList({Key? key, required this.sortOrder}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(sortedProvider(sortOrder));
    return names.when(
      data: (data) => ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: BasicNameRow(key: ValueKey(item.key()), nameData: item));
        },
      ),
      loading: () => const LoadingBox(),
      error: (error, trace) => ErrorBox(error, trace),
    );
  }
}