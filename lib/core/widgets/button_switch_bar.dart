import 'package:flutter/material.dart';
import 'package:yomikun/core/models.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/search/models.dart';

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

  ButtonSwitchBar.forValue(ValueNotifier<T> v, {required this.items, Key? key})
      : value = v.value,
        onChanged = ((w) => v.value = w),
        super(key: key);

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

// Button switch bar for toggling between surname and given name. Localised.
class SeiMeiButtonSwitchBar extends StatelessWidget {
  final NamePart value;
  final ValueChanged<NamePart> onChanged;

  const SeiMeiButtonSwitchBar({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  SeiMeiButtonSwitchBar.forValue(ValueNotifier<NamePart> v)
      : value = v.value,
        onChanged = ((w) => v.value = w);

  @override
  Widget build(BuildContext context) {
    return ButtonSwitchBar<NamePart>(
      value: value,
      onChanged: onChanged,
      items: [
        MapEntry(NamePart.sei, context.loc.surname),
        MapEntry(NamePart.mei, context.loc.givenName),
      ],
    );
  }
}

/// Button switch bar for selecting between female, male and all genders.
/// Localised.
class GenderFilterButtonSwitchBar extends StatelessWidget {
  final GenderFilter value;
  final ValueChanged<GenderFilter> onChanged;

  const GenderFilterButtonSwitchBar({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  GenderFilterButtonSwitchBar.forValue(ValueNotifier<GenderFilter> v)
      : value = v.value,
        onChanged = ((w) => v.value = w);

  @override
  Widget build(BuildContext context) {
    return ButtonSwitchBar<GenderFilter>(
      value: value,
      onChanged: onChanged,
      items: [
        MapEntry(GenderFilter.female, context.loc.femaleGender),
        MapEntry(GenderFilter.male, context.loc.maleGender),
        MapEntry(GenderFilter.all, context.loc.allGenders),
      ],
    );
  }
}
