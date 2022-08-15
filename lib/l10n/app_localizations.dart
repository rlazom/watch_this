import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'localization_strings_en.dart';
import 'localization_strings_es.dart';

class AppLocalizations {
  /// singleton boilerplate
  static final AppLocalizations _appLocalizations = AppLocalizations._internal();

  factory AppLocalizations(locale) {
    _appLocalizations.locale = locale;
    return _appLocalizations;
  }

  AppLocalizations._internal();
  /// singleton boilerplate

  Locale locale = const Locale('en');

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static final Map<String, Map<String, String>> _localizedStrings = {
    'en': en,
    'es': es,
  };

  String get currentLanguage => locale.languageCode;
  String translate(String key, {String param = ''}) {
    return _localizedStrings[locale.languageCode]![key]?.replaceAll('[PARAM]', param) ?? '[$key]';
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
