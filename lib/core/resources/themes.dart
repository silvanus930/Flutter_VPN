import 'package:flutter/material.dart';
import 'package:nerdvpn/core/resources/colors.dart';

ThemeData get lightTheme => ThemeData.light().copyWith(
      primaryColor: primaryColor,
      backgroundColor: backgroundLight,
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all(primaryColor),
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        background: backgroundLight,
        secondary: secondaryColor,
        brightness: Brightness.light,
        shadow: shadowColor,
        surface: surfaceLight,
      ),
    );

ThemeData get darkTheme => ThemeData.dark().copyWith(
      primaryColor: primaryColor,
      backgroundColor: backgroundDark,
      scaffoldBackgroundColor: backgroundDark,
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all(primaryColor),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        background: backgroundDark,
        secondary: secondaryColor,
        brightness: Brightness.dark,
        shadow: shadowColor,
        surface: surfaceDark,
      ),
    );

TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;
