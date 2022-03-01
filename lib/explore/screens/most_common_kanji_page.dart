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
import 'package:yomikun/name_list/name_list_page.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/settings/settings_controller.dart';

/// Shows most common kanji in names
class MostCommonKanjiPage extends HookConsumerWidget {
  const MostCommonKanjiPage({Key? key}) : super(key: key);

  static const String routeName = '/explore/most-common-kanji';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namePart = useState<NamePart>(NamePart.sei);
    final genderFilter = useState<GenderFilter>(GenderFilter.all);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Most common name kanji'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ButtonSwitchBar(
              value: namePart.value,
              onChanged: (NamePart value) {
                namePart.value = value;
              },
              items: const [
                MapEntry(NamePart.mei, 'Given name'),
                MapEntry(NamePart.sei, 'Surname'),
              ],
            ),
            if (namePart.value == NamePart.mei)
              ButtonSwitchBar(
                value: genderFilter.value,
                onChanged: (GenderFilter value) {
                  genderFilter.value = value;
                },
                items: const [
                  MapEntry(GenderFilter.female, 'Female'),
                  MapEntry(GenderFilter.male, 'Male'),
                  MapEntry(GenderFilter.all, 'All'),
                ],
              ),
            Expanded(
              child: MostCommonKanjiList(
                namePart: namePart.value,
                genderFilter: genderFilter.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MostCommonKanjiFilter extends Equatable {
  const MostCommonKanjiFilter({
    required this.namePart,
    required this.genderFilter,
  });

  final NamePart namePart;
  final GenderFilter genderFilter;

  @override
  List<Object> get props => [namePart, genderFilter];
}

final mostCommonKanjiProvider = FutureProvider.family((ref, filter) => ref
    .read(databaseProvider)
    .getMostCommonKanji(filter.namePart, filter.genderFilter));

class MostCommonKanjiList extends ConsumerWidget {
  final NamePart namePart;
  final GenderFilter genderFilter;

  const MostCommonKanjiList(
      {Key? key, required this.namePart, this.genderFilter = GenderFilter.all})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = MostCommonKanjiFilter(
      namePart: namePart,
      genderFilter: genderFilter,
    );
    final names = ref.watch(mostCommonKanjiProvider(filter));
    return names.when(
      data: (data) => MostCommonKanjiListInner(results: data),
      loading: () => const LoadingBox(),
      error: (error, trace) => ErrorBox(error, trace),
    );
  }
}

class MostCommonKanjiListInner extends ConsumerWidget {
  final List<MostCommonKanji> results;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(mostPopularNamesKyProvider(KyPart(part, ky)));
    final formatPref =
        ref.watch(settingsControllerProvider.select((s) => s.nameFormat));

    return names.when(
      data: (data) => ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              children: [
                Text(formatYomiString(item.key, formatPref), style: textStyle),
                const Spacer(),
                Text(addThousands(item.value), style: textStyle),
              ],
            ),
          );
        },
      ),
      loading: () => const LoadingBox(),
      error: (error, trace) => ErrorBox(error, trace),
    );
  }
}
