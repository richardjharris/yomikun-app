import 'package:flutter/material.dart';
import 'package:yomikun/models/namedata.dart';

class NameRow extends StatelessWidget {
  const NameRow({
    required Key key,
    required this.nameData,
  }) : super(key: key);

  final NameData nameData;

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

    double genderScore = nameData.genderMlScore;
    return ListTile(
      title: Row(children: [
        Text(nameData.kaki, style: kakiStyle),
        Container(
            child: Text(nameData.yomi, style: yomiStyle),
            margin: const EdgeInsets.only(left: 10.0)),
      ]),
      subtitle: Row(children: [
        Align(
          child: SizedBox(
              width: 60,
              child: LinearProgressIndicator(
                value: genderScore,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                backgroundColor: Colors.blueAccent,
              )),
          alignment: Alignment.topLeft,
        ),
        Expanded(
            child: Text(
          "M: ${nameData.hitsMale} F: ${nameData.hitsFemale} U: ${nameData.hitsUnknown}",
          textAlign: TextAlign.right,
          style: hitsStyle,
        )),
      ]),
    );
  }
}
