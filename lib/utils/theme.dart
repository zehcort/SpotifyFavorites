import 'package:flutter/material.dart';

ThemeData mainTheme() {
  return ThemeData(
      primarySwatch: Colors.green,
      primaryColor: Color(0xFF00B43E),
      accentColor: Color(0xFF00B43E),
      cardColor: Color(0x53535300),
      scaffoldBackgroundColor: Color(0x00000000),
      backgroundColor: Color(0x00000000),
      fontFamily: 'Montserrat',
      textTheme: TextTheme(
          headline6: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
          subtitle2: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          bodyText2: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
          bodyText1: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
          subtitle1: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
          button: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
      buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF00B43E),
          shape: RoundedRectangleBorder(),
          textTheme: ButtonTextTheme.primary));
}
