import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yomikun/core/utilities/number_format.dart';
import 'package:yomikun/core/widgets/name_icons.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/search/models.dart';
import 'package:yomikun/settings/settings_controller.dart';

/// Shows name data with no interactivity.
class BasicNameRow extends ConsumerWidget {
  final NameData nameData;
  final KakiYomi? showOnly;

  /// If set, shows each name's share relative to the total hit count.
  final int? totalHits;

  /// If true, show [NamePart] as an icon on the left of each row.
  final bool showNamePart;

  final VoidCallback? onTap;

  const BasicNameRow({
    required Key key,
    required this.nameData,
    this.showOnly,
    this.totalHits,
    this.showNamePart = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatPref =
        ref.watch(settingsControllerProvider.select((p) => p.nameFormat));

    // Styles depend on current theme (light/dark)
    final theme = Theme.of(context).primaryTextTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final kakiStyle = theme.displayLarge!.copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : Colors.black);
    final yomiStyle = theme.displayMedium!.copyWith(
        fontSize: 18.0,
        color: isDark ? Colors.white70 : Colors.black87,
        fontWeight: isDark ? FontWeight.w400 : FontWeight.w500);
    final hitsStyle = theme.bodyLarge!.copyWith(
      fontSize: 14.0,
      color: isDark ? Colors.white54 : Colors.black45,
      fontWeight: isDark ? FontWeight.w400 : FontWeight.w500,
    );
    final pseudoHitsStyle = hitsStyle.copyWith(
      color: isDark ? Colors.yellow : const Color.fromARGB(255, 14, 97, 18),
    );

    List<Widget> titleWidgets = [];
    if (showOnly == null) {
      titleWidgets = [
        Text(nameData.kaki, style: kakiStyle, locale: const Locale('ja')),
        Container(
            margin: const EdgeInsets.only(left: 10.0),
            child: Text(nameData.formatYomi(formatPref),
                style: yomiStyle, locale: const Locale('ja'))),
      ];
    } else if (showOnly == KakiYomi.kaki) {
      titleWidgets = [Text(nameData.kaki, locale: const Locale('ja'))];
    } else {
      titleWidgets = [
        Text(nameData.formatYomi(formatPref), locale: const Locale('ja'))
      ];
    }

    if (totalHits != null && totalHits! > 0) {
      // Add a bar showing relative share.
      titleWidgets.add(const Spacer());
      titleWidgets.add(Container(
        width: 200.0 * (nameData.hitsTotal / totalHits!),
        height: 5.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.green,
        ),
      ));
    }

    return ListTile(
      onTap: onTap,
      leading: showNamePart ? NamePartIcon(nameData.part) : null,
      title: Row(children: titleWidgets),
      subtitle: Row(children: [
        if (nameData.part == NamePart.mei) GenderBar(nameData.femaleRatio),
        const Spacer(),
        if (nameData.hitsPseudo > 0 &&
            nameData.hitsPseudo / nameData.hitsTotal > 0.1) ...[
          Text(
            '${context.loc.nameRowFict} ${addThousands(nameData.hitsPseudo)}',
            style: pseudoHitsStyle,
            textAlign: TextAlign.right,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          "${context.loc.nameRowM} ${addThousands(nameData.hitsMale)}"
          " ${context.loc.nameRowF} ${addThousands(nameData.hitsFemale)}"
          " ${context.loc.nameRowU} ${addThousands(nameData.hitsUnknown)}",
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
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: LinearProgressIndicator(
            value: femaleRatio,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
            backgroundColor: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
