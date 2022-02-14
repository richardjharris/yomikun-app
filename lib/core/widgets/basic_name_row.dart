import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/utilities/number_format.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/settings/settings_controller.dart';

/// Shows name data with no interactivity.
class BasicNameRow extends ConsumerWidget {
  const BasicNameRow({
    required Key key,
    required this.nameData,
    this.showOnly,
  }) : super(key: key);

  final NameData nameData;
  final KakiYomi? showOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatPref =
        ref.watch(settingsControllerProvider.select((p) => p.nameFormat));

    // Styles depend on current theme (light/dark)
    final theme = Theme.of(context).primaryTextTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final kakiStyle = theme.headline1!.copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : Colors.black);
    final yomiStyle = theme.headline2!.copyWith(
        fontSize: 18.0,
        color: isDark ? Colors.white70 : Colors.black87,
        fontWeight: isDark ? FontWeight.w400 : FontWeight.w500);
    final hitsStyle = theme.bodyText1!.copyWith(
      fontSize: 14.0,
      color: isDark ? Colors.white54 : Colors.black45,
      fontWeight: isDark ? FontWeight.w400 : FontWeight.w500,
    );
    final pseudoHitsStyle = hitsStyle.copyWith(
      color: isDark ? Colors.yellow : Color.fromARGB(255, 14, 97, 18),
    );

    List<Widget> titleWidgets = [];
    if (showOnly == null) {
      titleWidgets = [
        Text(nameData.kaki, style: kakiStyle),
        Container(
            child: Text(nameData.yomi,
                style: yomiStyle, locale: const Locale('ja')),
            margin: const EdgeInsets.only(left: 10.0)),
      ];
    } else if (showOnly == KakiYomi.kaki) {
      titleWidgets = [Text(nameData.kaki, locale: const Locale('ja'))];
    } else {
      titleWidgets = [
        Text(nameData.formatYomi(formatPref), locale: const Locale('ja'))
      ];
    }

    // TODO M/F/U
    // TODO rename genderMlScore
    int genderScore = nameData.genderMlScore;
    return ListTile(
      title: Row(children: titleWidgets),
      subtitle: Row(children: [
        if (nameData.part == NamePart.mei) GenderBar(genderScore / 255),
        const Spacer(),
        if (nameData.hitsPseudo > 0) ...[
          Text(
            'Fict: ${addThousands(nameData.hitsPseudo)}',
            style: pseudoHitsStyle,
            textAlign: TextAlign.right,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          "M: ${addThousands(nameData.hitsMale)} F: ${addThousands(nameData.hitsFemale)} U: ${addThousands(nameData.hitsUnknown)}",
          textAlign: TextAlign.right,
          style: hitsStyle,
        ),
      ]),
    );
  }
}

class GenderBar extends StatelessWidget {
  final double femaleRatio;

  const GenderBar(this.femaleRatio);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SizedBox(
          width: 60,
          child: LinearProgressIndicator(
            value: femaleRatio,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
            backgroundColor: Colors.blueAccent,
          )),
      alignment: Alignment.topLeft,
    );
  }
}
