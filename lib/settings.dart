import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemePref { system, light, dark }

class SettingsController extends ChangeNotifier {
  static const _kLang = 'lang';
  static const _kTheme = 'theme';

  Locale _locale = const Locale('uz');
  ThemePref _theme = ThemePref.system;

  Locale get locale => _locale;
  ThemePref get theme => _theme;

  Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    final lang = sp.getString(_kLang);
    final theme = sp.getString(_kTheme);

    if (lang != null && lang.isNotEmpty) {
      _locale = Locale(lang);
    }
    if (theme != null) {
      _theme = ThemePref.values.firstWhere(
        (e) => e.name == theme,
        orElse: () => ThemePref.system,
      );
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kLang, locale.languageCode);
    notifyListeners();
  }

  Future<void> setTheme(ThemePref pref) async {
    _theme = pref;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kTheme, pref.name);
    notifyListeners();
  }

  ThemeMode get themeMode {
    return switch (_theme) {
      ThemePref.light => ThemeMode.light,
      ThemePref.dark => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
