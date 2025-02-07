import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Tema'),
              trailing: DropdownButton<ThemeMode>(
                value: themeProvider.themeMode,
                onChanged: (ThemeMode? mode) {
                  if (mode != null) {
                    themeProvider.setThemeMode(mode);
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('Sistem'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Açık'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Koyu'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('Dil'),
              trailing: DropdownButton<String>(
                value: localeProvider.locale.languageCode,
                onChanged: (String? languageCode) {
                  if (languageCode != null) {
                    localeProvider.setLocale(Locale(languageCode));
                  }
                },
                items: LocaleProvider.supportedLanguages.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
