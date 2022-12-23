import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/core/services/name_database.dart';
import 'package:yomikun/core/utilities/gender_color.dart';
import 'package:yomikun/core/widgets/error_box.dart';
import 'package:yomikun/core/widgets/loading_box.dart';
import 'package:yomikun/localization/app_localizations_context.dart';

final kanjiStatsProvider = FutureProvider((ref) {
  final db = ref.read(databaseProvider);
  return db.getKanjiByFemaleRatio();
});

/// Page showing kanji most commonly associated with male or female names.
class KanjiAndGenderPage extends HookConsumerWidget {
  const KanjiAndGenderPage({Key? key}) : super(key: key);

  static const String routeName = '/explore/kanji-and-gender';
  static const int initialMinHits = 3000;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiStats = ref.watch(kanjiStatsProvider);
    final minHits = useState<int>(initialMinHits);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.exKanjiAndGender),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(context.loc.exKanjiAndGenderDescription),
              ),
            ),
            const SizedBox(height: 10),
            Text('${context.loc.exKanjiAndGenderMinHits} ${minHits.value}'),
            Slider(
              value: minHits.value.toDouble(),
              max: initialMinHits.toDouble(),
              onChanged: (value) => minHits.value = value.round(),
            ),
            Expanded(
              child: kanjiStats.map(
                data: (x) => KanjiGrid(x.value, minHits: minHits.value),
                loading: (_) => const LoadingBox(),
                error: (error) => ErrorBox(error, error.stackTrace),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KanjiGrid extends StatelessWidget {
  final List<KanjiStats> data;
  final int minHits;

  const KanjiGrid(this.data, {Key? key, this.minHits = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = data.where((x) => x.hitsTotal >= minHits).toList();

    // Display a grid of kanji from data
    return CustomScrollView(
      primary: false,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 42.0),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = items[index];
                final tileColor = genderColor(item.femaleRatio);
                return Container(
                  width: 42,
                  height: 42,
                  color: tileColor,
                  key: ValueKey(item.kanji),
                  child: Center(
                    child: Text(
                      item.kanji,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        textBaseline: TextBaseline.ideographic,
                        locale: Locale('ja', 'JA'),
                      ),
                    ),
                  ),
                );
              },
              childCount: items.length,
            ),
          ),
        ),
      ],
    );
  }
}
