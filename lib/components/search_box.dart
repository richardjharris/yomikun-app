import 'package:flutter/material.dart';

final modes = ['Mei', 'Sei', 'Browse'];
final icons = ['名', '姓', '＊'];

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final String dropdownValue;
  final Function(String?) onDropdownValueChanged;

  const SearchBox(
      {required this.controller,
      required this.dropdownValue,
      required this.onDropdownValueChanged,
      key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final modeIndex = modes.indexOf(dropdownValue);
    return Row(children: [
      Expanded(
          child: TextField(
        controller: controller,
        autofocus: true,
        textInputAction: TextInputAction.search,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).primaryColorLight,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => controller.clear(),
          ),
        ),
      )),
      const SizedBox(width: 10),
      IconButton(
        icon: Text(icons[modeIndex]),
        onPressed: advanceMode,
        iconSize: 30,
      ),
    ]);
  }

  void advanceMode() {
    // advance to next mode
    final index = modes.indexOf(dropdownValue);
    final nextIndex = (index + 1) % modes.length;
    final nextMode = modes[nextIndex];
    onDropdownValueChanged(nextMode);
  }
}
