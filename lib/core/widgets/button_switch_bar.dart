import 'package:flutter/material.dart';

/// Bar of buttons, where only one button can be selected at once.
class ButtonSwitchBar<T> extends StatelessWidget {
  /// Selected item.
  final T value;

  /// Callback for when the selected item changes.
  final ValueChanged<T> onChanged;

  /// Ordered list of [MapEntry] mapping items to their textual labels.
  final List<MapEntry<T, String>> items;

  const ButtonSwitchBar({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = items.map((item) => item.key == value).toList();
    return ToggleButtons(
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(item.value),
              ))
          .toList(),
      onPressed: (int index) {
        onChanged(items[index].key);
      },
      isSelected: isSelected,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );
  }
}
