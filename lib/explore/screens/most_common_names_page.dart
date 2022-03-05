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
import 'package:yomikun/name_list/name_list_page.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/settings/settings_controller.dart';

enum _ViewMode { kanji, kana, exact }

/// Page showing family names ordered by popularity.
///
/// The widget also allows toggling between most common kanji, kana and
/// combination of the two.
class MostCommonNamesPage extends HookConsumerWidget {
  final NamePart part;

  const MostCommonNamesPage({Key? key, required this.part}) : super(key: key);

  static const String routeNameFamily = '/explore/most-common-family-names';
  static const String routeNameGiven = '/explore/most-common-given-names';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = useState<_ViewMode>(_ViewMode.exact);

    Widget inner;
    switch (viewMode.value) {
      case _ViewMode.exact:
        inner = _TopExactNames(part);
        break;
      case _ViewMode.kana:
        inner = _TopNames(part, KakiYomi.yomi);
        break;
      case _ViewMode.kanji:
        inner = _TopNames(part, KakiYomi.kaki);
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          part == NamePart.mei
              ? context.loc.exMostCommonGivenNames
              : context.loc.exMostCommonFamilyNames,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ButtonSwitchBar(
              value: viewMode.value,
              onChanged: (_ViewMode value) {
                viewMode.value = value;
              },
              items: const [
                MapEntry(_ViewMode.exact, 'Exact'),
                MapEntry(_ViewMode.kanji, 'Kanji'),
                MapEntry(_ViewMode.kana, 'Kana'),
              ],
            ),
            Expanded(child: inner),
          ],
        ),
      ),
    );
  }
}

final mostPopularNamesProvider = FutureProvider.family((ref, NamePart part) {
  final db = ref.watch(databaseProvider);
  return db.getMostPopular(part, limit: 100);
});

class _TopExactNames extends ConsumerWidget {
  final NamePart part;

  const _TopExactNames(this.part);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(mostPopularNamesProvider(part));
    return names.when(
      data: (data) => NameListPage(results: data),
      loading: () => const LoadingBox(),
      error: (error, trace) => ErrorBox(error, trace),
    );
  }
}

class KyPart extends Equatable {
  final KakiYomi ky;
  final NamePart part;

  const KyPart(this.part, this.ky);

  @override
  List<Object> get props => [ky, part];
}

final mostPopularNamesKyProvider = FutureProvider.family((ref, KyPart kypart) =>
    ref
        .read(databaseProvider)
        .getMostPopularKY(kypart.part, kypart.ky, limit: 100));

class _TopNames extends ConsumerWidget {
  const _TopNames(this.part, this.ky, {Key? key}) : super(key: key);

  final NamePart part;
  final KakiYomi ky;

  final textStyle = const TextStyle(fontSize: 20);

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
