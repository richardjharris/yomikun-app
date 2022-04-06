import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yomikun/localization/app_localizations_context.dart';
import 'package:yomikun/settings/models/settings_models.dart';
import 'package:yomikun/settings/settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
              onChanged: (value) =>
                  _updateAppLanguage(value, settings, context),
              items: {
                AppLanguagePreference.system: context.loc.systemLanguage,
                AppLanguagePreference.en: context.loc.englishLanguage,
                AppLanguagePreference.ja: context.loc.japaneseLanguage,
              },
            ),
            DropdownSettingsTile<NameFormatPreference>(
              title: context.loc.nameDisplayFormat,
              value: settings.nameFormat,
              onChanged: settings.updateNameFormat,
              items: {
                NameFormatPreference.hiragana: context.loc.nameDisplayHiragana,
                NameFormatPreference.hiraganaBigAccent:
                    context.loc.nameDisplayHiraganaBigAccent,
                NameFormatPreference.romaji: context.loc.nameDisplayRomaji,
              },
            ),
            DropdownSettingsTile<NameVisualizationPreference>(
              title: context.loc.nameVisualization,
              value: settings.nameVisualization,
              onChanged: settings.updateNameVisualization,
              items: {
                NameVisualizationPreference.treeMap: context.loc.nameVizTreeMap,
                NameVisualizationPreference.pieChart:
                    context.loc.nameVizPieChart,
                NameVisualizationPreference.none: context.loc.nameVizNone,
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateAppLanguage(AppLanguagePreference? newLanguage,
      SettingsController settings, BuildContext context) {
    settings.updateAppLanguage(newLanguage);

    // Users changing to Japanese language probably do not want romaji.
    if (newLanguage == AppLanguagePreference.ja &&
        settings.nameFormat == NameFormatPreference.romaji) {
      settings.updateNameFormat(NameFormatPreference.hiragana);

      final snackbar = SnackBar(
        content: Text(context.loc.settingsChangedNameFormatToHiragana),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}

/// Generic settings tile that displays a dropdown menu.
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
