import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/providers/core_providers.dart';
import 'package:yomikun/core/services/name_database.dart';
import 'package:yomikun/core/utilities/gender_color.dart';
import 'package:yomikun/core/widgets/error_box.dart';
import 'package:yomikun/core/widgets/loading_box.dart';

final kanjiStatsProvider = FutureProvider((ref) {
  final db = ref.read(databaseProvider);
  return db.getKanjiByFemaleRatio();
});

/// Page showing kanji most commonly associated with male or female names.
class KanjiAndGenderPage extends HookConsumerWidget {
  const KanjiAndGenderPage({Key? key}) : super(key: key);

  static const String routeName = '/explore/kanji-and-gender';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiStats = ref.watch(kanjiStatsProvider);
    final minHits = useState<int>(500);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanji and gender'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'This is a map of kanji most associated with men (blue) or women (pink) based on aggregate name data.',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text('Minimum hits: ${minHits.value}'),
            Slider(
              value: minHits.value.toDouble(),
              max: 1000,
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
                  key: ValueKey(item.kanji),
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
