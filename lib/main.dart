import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/providers.dart';
import 'common/providers/language_provider.dart';
import 'common/routes.dart';
import 'common/themes.dart';
import 'l10n/app_localizations.dart';
import 'services/navigation_service.dart';
import 'services/shared_preferences_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService().initialize();

  runApp(
    EasyDynamicThemeWidget(
      child: const WatchThisApp(),
    ),
  );
}

class WatchThisApp extends StatelessWidget {
  const WatchThisApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const appName = 'Watch This';

    return MultiProvider(
      providers: providers,
      child: Consumer<LanguageProvider>(
        builder: (context, locale, child) {
          return MaterialApp(
            title: appName,
            theme: themeLight,
            // theme: ThemeData.light(),
            // darkTheme: ThemeData.dark(),
            themeMode: EasyDynamicTheme.of(context).themeMode,
            locale: locale.currentLocale,
            supportedLocales: locale.supportedLocales,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale == null) {
                return supportedLocales.first;
              }
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return locale;
                }
              }
              return supportedLocales.first;
            },
            routes: routes,
            initialRoute: MainPage.route,
            navigatorKey: NavigationService().navigatorKey,
          );
        }
      ),
    );
  }
}