import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

class AppStrings {
  final Locale locale;
  final Map<String, String> _m;

  AppStrings(this.locale, this._m);

  static const supportedLocales = [
    Locale('en'),
    Locale('uz'),
    Locale('ru'),
  ];

  static Future<AppStrings> load(Locale locale) async {
    final code = locale.languageCode;
    final path = 'l10n/app_$code.arb';
    final raw = await rootBundle.loadString(path);
    final data = json.decode(raw) as Map<String, dynamic>;
    final m = <String, String>{};
    data.forEach((k, v) {
      if (!k.startsWith('@')) m[k] = v.toString();
    });
    return AppStrings(locale, m);
  }

  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings)!;
  }

  String t(String key) => _m[key] ?? key;
}

class AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const AppStringsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppStrings.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) => AppStrings.load(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppStrings> old) => false;
}
