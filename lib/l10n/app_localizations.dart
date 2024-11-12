import 'dart:developer' show log;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'localization_strings.dart';

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

  // static final Map<String, Map<String, String>> _localizedStrings = {
  //   'en': en,
  //   'es': es,
  // };

  String get currentLanguage => locale.languageCode;

  static List get _supportedLocalesList => localizedStrings.keys.toList();
  static get supportedLocales => _supportedLocalesList.map((e) => Locale(e));
  static Map<String, Map<String, String>> get _localizedStrings => localizedStrings;

  String translate(String key, {String param = '', String? defaultValue}) {
    return _localizedStrings[locale.languageCode]![key]?.replaceAll('[PARAM]', param) ?? defaultValue ?? '[$key]';
  }

  static Locale localeResolutionCallback(Locale? locale, Iterable<Locale> supportedLocales, {String? mockLocale}) {
    log('AppLocalizations - localeResolutionCallback() - locale: "$locale", mockLocale: "${mockLocale?.toLowerCase()}", supportedLocales: "${_supportedLocalesList.join(',')}"');
    if (mockLocale != null) {
      mockLocale = mockLocale.toLowerCase();
      Locale? sl;
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == mockLocale) {
          sl = supportedLocale;
          break;
        }
      }
      if (sl != null) {
        return Locale(mockLocale);
      } else {
        return supportedLocales.first;
      }
    }

    if (locale == null) {
      return supportedLocales.first;
    }
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
    return supportedLocales.first;
    // return supportedLocales.last;
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
