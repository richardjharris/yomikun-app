import 'package:flutter/material.dart';
import 'package:yomikun/core/locale.dart';
import 'package:yomikun/core/number_format.dart';
import 'package:yomikun/models/namedata.dart';

/// Shows name data with no interactivity.
class BasicNameRow extends StatelessWidget {
  const BasicNameRow({
    required Key key,
    required this.nameData,
    this.showOnly,
  }) : super(key: key);

  final NameData nameData;
  final KakiYomi? showOnly;

  @override
  Widget build(BuildContext context) {
    // Styles depend on current theme (light/dark)
    var theme = Theme.of(context).primaryTextTheme;
    var isDark = Theme.of(context).brightness == Brightness.dark;
    var kakiStyle = theme.headline1!.copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : Colors.black);
    var yomiStyle = theme.headline2!.copyWith(
        fontSize: 18.0,
        color: isDark ? Colors.white70 : Colors.black87,
        fontWeight: isDark ? FontWeight.w400 : FontWeight.w500);
    var hitsStyle = theme.bodyText1!.copyWith(
      fontSize: 14.0,
      color: isDark ? Colors.white54 : Colors.black45,
      fontWeight: isDark ? FontWeight.w400 : FontWeight.w500,
    );

    List<Widget> titleWidgets = [];
    if (showOnly == null) {
      titleWidgets = [
        Text(nameData.kaki, style: kakiStyle),
        Container(
            child:
                Text(nameData.yomi, style: yomiStyle, locale: japaneseLocale),
            margin: const EdgeInsets.only(left: 10.0)),
      ];
    } else if (showOnly == KakiYomi.kaki) {
      titleWidgets = [Text(nameData.kaki, locale: japaneseLocale)];
    } else {
      titleWidgets = [Text(nameData.yomi, locale: japaneseLocale)];
    }

    int genderScore = nameData.genderMlScore;
    return ListTile(
      title: Row(children: titleWidgets),
      subtitle: Row(children: [
        Align(
          child: SizedBox(
              width: 60,
              child: LinearProgressIndicator(
                value: genderScore / 255,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                backgroundColor: Colors.blueAccent,
              )),
          alignment: Alignment.topLeft,
        ),
        Expanded(
            child: Text(
          "M: ${addThousands(nameData.hitsMale)} F: ${addThousands(nameData.hitsFemale)} U: ${addThousands(nameData.hitsUnknown)}",
          textAlign: TextAlign.right,
          style: hitsStyle,
        )),
      ]),
    );
  }
}
