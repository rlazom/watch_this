import 'package:flutter/material.dart';
import 'constants.dart';

final Color kPrimaryColor = R.colors.primary;
final Color kSecondaryColor = R.colors.primaries.green1;

final Color kTextColor = kSecondaryColor;
final Color kText1Color = kTextColor.withOpacity(0.7);
final Color kText2Color = kTextColor.withOpacity(0.54);

ThemeData themeLight = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: kPrimaryColor,
  secondaryHeaderColor: kSecondaryColor,
  fontFamily: 'Quicksand',
  textTheme: TextTheme(
    // caption: const TextStyle(color: Colors.pink),
    displayLarge: TextStyle(
        color: kTextColor, fontSize: 16.0, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(
      color: kTextColor,
      fontSize: 14.0,
    ),
    // headline4: const TextStyle(color: Colors.yellow),
    // headline5: const TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),

    /// Small texts (ex: Movie Tile text under Movie Title)
    titleSmall: TextStyle(
        fontSize: 10.0, color: kText2Color, fontStyle: FontStyle.italic),

    /// DEFAULT TEXT STYLE
    bodyMedium: TextStyle(
        fontSize: 12.0, color: kText2Color, fontStyle: FontStyle.normal),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: kPrimaryColor,
    brightness: Brightness.dark,
  ),
);
