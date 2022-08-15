import 'package:provider/provider.dart';
import 'providers/language_provider.dart';
import 'providers/user_provider.dart';

var providers = [
  ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
  ChangeNotifierProvider<LanguageProvider>(create: (context) => LanguageProvider()),
  // ChangeNotifierProvider<LanguageProvider>(: (context) => LanguageProvider()),
  // ChangeNotifierProvider.value(value: LanguageProvider()),
];