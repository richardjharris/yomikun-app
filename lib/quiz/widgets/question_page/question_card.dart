import 'package:flutter/material.dart' hide IconData;
import 'package:yomikun/core/widgets/name_icons.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/search/models.dart';

/// [Card] that shows a question with optional sublabel.
class QuestionCard extends StatelessWidget {
  final String label;
  final NamePart? part;

  /// Maximum font size for the card text. May be scaled down to fit.
  final double? fontSize;

  const QuestionCard(this.label, {this.part, this.fontSize, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: _buildCardInner(),
      ),
    );
  }

  Widget _buildCardInner() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FittedBox(
              child: Text(
                label,
                locale: const Locale('ja', 'JP'),
                style: TextStyle(fontSize: fontSize),
              ),
              fit: BoxFit.scaleDown,
            ),
          ),
          if (part != null) PartLabel(part: part!)
        ],
      ),
    );
  }
}

class PartLabel extends StatelessWidget {
  final NamePart part;

  const PartLabel({Key? key, required this.part}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(part == NamePart.mei || part == NamePart.sei);

    final brightness = Theme.of(context).brightness;
    final color = brightness == Brightness.light
        ? IconData.forNamePart(part).lightColor
        : IconData.forNamePart(part).darkColor;

    final label =
        part == NamePart.mei ? context.loc.givenName : context.loc.surname;

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: color,
        child: Text(
          label,
          style: const TextStyle(fontSize: 24),
        ),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
      ),
    );
  }
}
