import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  Locale _locale;

  LocaleProvider(this._prefs)
      : _locale = Locale(_prefs.getString('languageCode') ?? 'tr');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    _prefs.setString('languageCode', locale.languageCode);
    notifyListeners();
  }

  static const Map<String, String> supportedLanguages = {
    'tr': 'Türkçe',
    'en': 'English',
  };

  static const List<Locale> supportedLocales = [
    Locale('tr'),
    Locale('en'),
  ];

  static bool isSupported(Locale locale) {
    return supportedLanguages.containsKey(locale.languageCode);
  }
}
