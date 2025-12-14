import 'package:flutter/material.dart';
import '../l10n.dart';
import '../settings.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsController settings;
  const SettingsScreen({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(s.t('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle(title: s.t('language')),
          const SizedBox(height: 10),
          _LangTile(
            label: 'O‘zbek',
            selected: settings.locale.languageCode == 'uz',
            onTap: () => settings.setLocale(const Locale('uz')),
          ),
          _LangTile(
            label: 'English',
            selected: settings.locale.languageCode == 'en',
            onTap: () => settings.setLocale(const Locale('en')),
          ),
          _LangTile(
            label: 'Русский',
            selected: settings.locale.languageCode == 'ru',
            onTap: () => settings.setLocale(const Locale('ru')),
          ),
          const SizedBox(height: 20),
          _SectionTitle(title: s.t('theme')),
          const SizedBox(height: 10),
          _ThemeTile(
            label: s.t('system'),
            selected: settings.theme == ThemePref.system,
            onTap: () => settings.setTheme(ThemePref.system),
          ),
          _ThemeTile(
            label: s.t('light'),
            selected: settings.theme == ThemePref.light,
            onTap: () => settings.setTheme(ThemePref.light),
          ),
          _ThemeTile(
            label: s.t('dark'),
            selected: settings.theme == ThemePref.dark,
            onTap: () => settings.setTheme(ThemePref.dark),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
    );
  }
}

class _LangTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LangTile({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        trailing: selected ? Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary) : null,
        onTap: onTap,
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ThemeTile({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        trailing: selected ? Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary) : null,
        onTap: onTap,
      ),
    );
  }
}
