import 'package:flutter/material.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/search/models.dart';

/// Widgets for showing the type of name or search query.
///
/// These are grouped together as they should have consistent style and colour.

class IconData {
  static const mei = IconData(
    '名',
    'F',
    Color.fromARGB(255, 255, 177, 251),
    Color.fromARGB(255, 199, 93, 194),
  );
  static const sei = IconData(
    '姓',
    'S',
    Color.fromARGB(255, 245, 203, 141),
    Color.fromARGB(255, 196, 142, 63),
  );
  static const person = IconData(
    '人',
    'P',
    Color.fromARGB(255, 255, 250, 206),
    Color.fromARGB(255, 255, 250, 206),
  );
  static const wildcard = IconData(
    '✴',
    '∗',
    Color.fromARGB(255, 150, 214, 152),
    Color.fromARGB(255, 104, 156, 106),
  );
  static const unknown = IconData(
    '？',
    '?',
    Color.fromARGB(255, 177, 177, 177),
    Color.fromARGB(255, 129, 128, 128),
  );

  final String iconJa;
  final String iconEn;
  final Color lightColor;
  final Color darkColor;

  const IconData(this.iconJa, this.iconEn, this.lightColor, this.darkColor);

  /// Return the correct Icon based on application context (locale)
  String iconFor(BuildContext? context) {
    bool japanese = context?.isJapanese ?? false;
    return japanese ? iconJa : iconEn;
  }

  static IconData forQueryMode(QueryMode mode) {
    switch (mode) {
      case QueryMode.sei:
        return IconData.sei;
      case QueryMode.mei:
        return IconData.mei;
      case QueryMode.person:
        return IconData.person;
      case QueryMode.wildcard:
        return IconData.wildcard;
    }
  }

  static IconData forNamePart(NamePart part) {
    switch (part) {
      case NamePart.mei:
      case NamePart.sei:
      case NamePart.person:
        return IconData.forQueryMode(part.toQueryMode()!);
      case NamePart.unknown:
        return IconData.unknown;
    }
  }
}

String queryModeToIcon(QueryMode mode, [BuildContext? context]) {
  return IconData.forQueryMode(mode).iconFor(context);
}

String namePartToIcon(NamePart part, [BuildContext? context]) {
  return IconData.forNamePart(part).iconFor(context);
}

class QueryModeIcon extends StatelessWidget {
  final QueryMode mode;

  const QueryModeIcon(this.mode);

  @override
  Widget build(BuildContext context) {
    final data = IconData.forQueryMode(mode);
    return NameIcon(data);
  }
}

class NamePartIcon extends StatelessWidget {
  final NamePart part;

  const NamePartIcon(this.part);

  @override
  Widget build(BuildContext context) {
    final data = IconData.forNamePart(part);
    return NameIcon(data);
  }
}

class NameIcon extends StatelessWidget {
  final IconData data;

  const NameIcon(this.data);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final iconColor =
        brightness == Brightness.dark ? data.darkColor : data.lightColor;
    final iconText = data.iconFor(context);

    // return an icon for the namepart
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: iconColor,
      ),
      child: Center(
        child: Text(
          iconText,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          locale: const Locale('ja'),
        ),
      ),
    );
  }
}

class NameIconPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 30, width: 30);
  }
}
