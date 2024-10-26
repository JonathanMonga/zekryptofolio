import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.purple,
  brightness: Brightness.light,
  primaryColor: Colors.white,
  primaryColorLight: Colors.purple[700],
  dividerColor: Colors.grey[200],
  iconTheme: const IconThemeData(color: Colors.white),
  primaryIconTheme: const IconThemeData(color: Colors.black),
  disabledColor: Colors.grey[500],
);

final ThemeData darkTheme = ThemeData(
  cupertinoOverrideTheme: const CupertinoThemeData(
    textTheme: CupertinoTextThemeData(
      dateTimePickerTextStyle: TextStyle(color: Colors.white),
    ),
  ),
  fontFamily: GoogleFonts.roboto().fontFamily,
  primarySwatch: Colors.green,
  brightness: Brightness.dark,
  primaryColor: Colors.green.shade800,
  primaryColorLight: Colors.green.shade500,
  iconTheme: const IconThemeData(color: Colors.white),
  cardColor: const Color.fromRGBO(55, 55, 55, 1.0),
  dividerColor: const Color.fromRGBO(60, 60, 60, 1.0),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

final ThemeData darkThemeOLED = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color.fromRGBO(5, 5, 5, 1.0),
  canvasColor: Colors.black,
  primaryColorLight: Colors.deepPurple[300],
  cardColor: const Color.fromRGBO(16, 16, 16, 1.0),
  dividerColor: const Color.fromRGBO(20, 20, 20, 1.0),
  dialogBackgroundColor: Colors.black,
  iconTheme: const IconThemeData(color: Colors.white),
);
