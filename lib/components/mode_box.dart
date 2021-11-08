import 'package:flutter/material.dart';

/// Button component that toggles between the various interpretations of
/// the search query.
class ModeButton extends StatefulWidget {
  /// List of modes and their (text) icons
  static var modes = [
    "browse",
    "sei",
    "mei",
    "kana_sei",
    "kana_mei",
    "full_name",
  ];

  static var icons = [
    "※",
    "性",
    "名",
    "せ",
    "な",
    "人",
  ];

  /// Called when the mode is changed, passing the new mode name.
  final void Function(String) onChangeMode;

  const ModeButton({
    Key? key,
    required this.onChangeMode,
  }) : super(key: key);

  @override
  State<ModeButton> createState() => _ModeButtonState();
}

class _ModeButtonState extends State<ModeButton> {
  /// Last mode manually selected by the user. null means 'auto'
  String? lastSelectedMode;

  /// Modes that are currently available.
  List<String> enabledModes = ModeButton.modes;

  /// Current mode (index)
  int currentMode = 0;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Text(ModeButton.modes[currentMode]),
      onPressed: onPressed,
    );
  }

  void onPressed() {
    /// call widget.onChangeMode
  }
}
