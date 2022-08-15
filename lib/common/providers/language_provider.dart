import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/material.dart' show Locale;
import '../../services/shared_preferences_service.dart';

class LanguageProvider with ChangeNotifier {
  final SharedPreferencesService _sharedPreferencesService;

  LanguageProvider() : _sharedPreferencesService = SharedPreferencesService();

  get supportedLocales => const [
        Locale('en'),
        Locale('es'),
      ];

  String get currentLocaleStr =>
      currentLocale?.languageCode.toUpperCase() ?? 'Auto';

  String? fetchUserLocale() => _sharedPreferencesService.getUserLocale();

  Locale? get currentLocale {
    String? userLocale = fetchUserLocale();
    if (userLocale != null) {
      return Locale(userLocale);
    }
    return null;
  }

  /// A => EN => ES => ...
  toggleLocale() {
    const defaultLocale = Locale('en');
    Locale? locale = defaultLocale;
    String? userLocale = fetchUserLocale();

    if (userLocale == null) {
      locale = defaultLocale;
      _sharedPreferencesService.setUserLocale(locale.languageCode);
    } else {
      if (userLocale == 'en') {
        locale = const Locale('es');
        _sharedPreferencesService.setUserLocale(locale.languageCode);
      } else {
        locale = null;
        _sharedPreferencesService.removeUserLocale();
      }
    }
    notifyListeners();
  }
}
