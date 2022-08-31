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
  backgroundColor: R.colors.background,
  fontFamily: 'Quicksand',
  textTheme: TextTheme(
    // caption: const TextStyle(color: Colors.pink),
    headline1: TextStyle(color: kPrimaryColor, fontSize: 16.0, fontWeight: FontWeight.bold),
    headline2: TextStyle(color: kTextColor, fontSize: 14.0,),
    // headline4: const TextStyle(color: Colors.yellow),
    // headline5: const TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),

    /// Small texts (ex: Movie Tile text under Movie Title)
    headline6: TextStyle(fontSize: 10.0, color: kText2Color, fontStyle: FontStyle.italic),

    /// DEFAULT TEXT STYLE
    bodyText2: TextStyle(fontSize: 12.0, color: kText2Color, fontStyle: FontStyle.normal),
  ),
);