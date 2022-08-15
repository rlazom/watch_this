import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF009FE3),
  secondaryHeaderColor: const Color(0xFF009FE3),
  fontFamily: 'Quicksand',
  textTheme: const TextTheme(
    headline4: TextStyle(color: Colors.white),
    headline5: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
    headline6: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Color(0xFF009FE3)),
    bodyText2: TextStyle(fontSize: 14.0, fontStyle: FontStyle.normal),
  ),
);