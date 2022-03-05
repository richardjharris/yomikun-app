import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/core/utilities/number_format.dart';
import 'package:yomikun/core/widgets/button_switch_bar.dart';
import 'package:yomikun/core/widgets/error_box.dart';
import 'package:yomikun/core/widgets/loading_box.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/name_breakdown/name_breakdown_page.dart';
import 'package:yomikun/search/models.dart';

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
        title: Text(context.loc.exMostCommonKanji),
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
              items: [
                MapEntry(NamePart.mei, context.loc.givenName),
                MapEntry(NamePart.sei, context.loc.surname),
              ],
            ),
            if (namePart.value == NamePart.mei) ...[
              const SizedBox(height: 10),
              ButtonSwitchBar(
                value: genderFilter.value,
                onChanged: (GenderFilter value) {
                  genderFilter.value = value;
                },
                items: [
                  MapEntry(GenderFilter.female, context.loc.femaleGender),
                  MapEntry(GenderFilter.male, context.loc.maleGender),
                  MapEntry(GenderFilter.all, context.loc.allGenders),
                ],
              ),
            ],
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
  final NamePart namePart;
  final GenderFilter genderFilter;

  const MostCommonKanjiFilter(this.namePart, this.genderFilter);

  @override
  List<Object> get props => [namePart, genderFilter];
}

final mostCommonKanjiProvider = FutureProvider.family(
    (ref, MostCommonKanjiFilter filter) => ref
        .read(databaseProvider)
        .getMostCommonKanji(filter.namePart, filter.genderFilter));

class MostCommonKanjiList extends ConsumerWidget {
  final NamePart namePart;
  final GenderFilter genderFilter;

  const MostCommonKanjiList({Key? key, required this.namePart, genderFilter})
      : genderFilter =
            namePart == NamePart.mei ? genderFilter : GenderFilter.all,
        super(key: key);

  final kanjiTextStyle = const TextStyle(fontSize: 32);
  final countTextStyle = const TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = MostCommonKanjiFilter(namePart, genderFilter);
    final names = ref.watch(mostCommonKanjiProvider(filter));
    return names.when(
      data: (data) => ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              children: [
                Text(item.kanji,
                    style: kanjiTextStyle, locale: const Locale('ja', 'JP')),
                const Spacer(),
                Text(addThousands(item.hitsTotal), style: countTextStyle),
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
