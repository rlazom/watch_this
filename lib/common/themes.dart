import 'package:flutter/material.dart';
const Color kTextColor = Colors.white70;
const Color kText2Color = Colors.white54;

ThemeData themeLight = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF009FE3),
  secondaryHeaderColor: const Color(0xFF009FE3),
  fontFamily: 'Quicksand',
  textTheme: const TextTheme(
    caption: TextStyle(color: Colors.pink),
    headline1: TextStyle(color: kTextColor, fontSize: 16.0, fontWeight: FontWeight.bold),
    headline2: TextStyle(color: kTextColor, fontSize: 14.0,),
    headline4: TextStyle(color: Colors.yellow),
    headline5: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
    headline6: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Color(0xFF009FE3)),

    /// DEFAULT TEXT STYLE
    bodyText2: TextStyle(fontSize: 12.0, color: kText2Color, fontStyle: FontStyle.normal),
  ),
);