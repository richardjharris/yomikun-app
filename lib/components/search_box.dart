import 'package:flutter/material.dart';

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
      DropdownButton(
        value: dropdownValue,
        onChanged: onDropdownValueChanged,
        items: <String>['Mei', 'Sei', 'MeiKana', 'Browse']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      )
    ]);
  }
}
