import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yomikun/app/settings/settings_service.dart';
import 'package:yomikun/core/localized_buildcontext.dart';
import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends ConsumerWidget {
  const SettingsView({Key? key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text(context.loc.settings),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownSettingsTile<ThemeMode>(
                  title: context.loc.theme,
                  value: settings.themeMode,
                  onChanged: settings.updateThemeMode,
                  items: {
                    ThemeMode.system: context.loc.systemTheme,
                    ThemeMode.light: context.loc.lightTheme,
                    ThemeMode.dark: context.loc.darkTheme,
                  },
                ),
                DropdownSettingsTile<AppLanguagePreference>(
                  title: context.loc.appLanguage,
                  value: settings.appLanguage,
                  onChanged: settings.updateAppLanguage,
                  items: {
                    AppLanguagePreference.system: context.loc.systemLanguage,
                    AppLanguagePreference.en: context.loc.englishLanguage,
                    AppLanguagePreference.ja: context.loc.japaneseLanguage,
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class DropdownSettingsTile<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Map<T, String> items;
  final T value;
  final ValueChanged<T?> onChanged;

  const DropdownSettingsTile({
    Key? key,
    required this.title,
    this.subtitle,
    required this.items,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelLarge),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: Theme.of(context).textTheme.labelMedium),
        ],
        DropdownButton<T>(
          value: value,
          onChanged: onChanged,
          isExpanded: true,
          items: items.entries
              .map((item) =>
                  DropdownMenuItem(value: item.key, child: Text(item.value)))
              .toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
