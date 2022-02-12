import 'package:flutter/widgets.dart';

/// Generic class for showing a message where results would usually appear.
class PlaceholderMessage extends StatelessWidget {
  /// Message to display to the user. Will fill all available space.
  final String message;
  final double margin;

  const PlaceholderMessage(this.message, {this.margin = 15});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      alignment: Alignment.center,
      child: Text(message, textAlign: TextAlign.center),
    );
  }
}
