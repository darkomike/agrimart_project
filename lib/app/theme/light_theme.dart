import 'package:flutter/material.dart';
import '../constants/color_constant.dart';

class LightTheme {
  static TextTheme lightTextTheme = const TextTheme(
    bodyText1: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline1: TextStyle(
      fontSize: 48.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headline2: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headline3: TextStyle(
      fontSize: 16.0,
      color: Colors.black,
    ),
    headline6: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );

  // LIGHT THEME
  static ThemeData light() {
    return ThemeData(
      primaryColorLight: ColorConstants.primaryColor,
      primaryColorDark: ColorConstants.primaryColor,
      toggleableActiveColor: ColorConstants.primaryColor,
      focusColor: ColorConstants.primaryColor,
      dialogBackgroundColor: Colors.white,
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: ColorConstants.primaryColor,
          onPrimary: ColorConstants.primaryColor,
          secondary: ColorConstants.secondaryColor,
          onSecondary: ColorConstants.secondaryColor,
          error: ColorConstants.errorColor,
          onError: ColorConstants.errorColor,
          background: Colors.white,
          onBackground: Colors.white,
          surface: Colors.white,
          onSurface: Colors.white),
      progressIndicatorTheme: ProgressIndicatorThemeData(
          circularTrackColor: ColorConstants.primaryColor,
          refreshBackgroundColor: ColorConstants.primaryColor.withOpacity(0.5)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ColorConstants.primaryColor,
        selectedIconTheme: const IconThemeData(color: Colors.white, size: 16),
        unselectedIconTheme: const IconThemeData(color: Colors.white, size: 14),
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w300),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 10,
      ),
      backgroundColor: Colors.white,
      inputDecorationTheme:
          InputDecorationTheme(fillColor: ColorConstants.primaryColor),
      primaryColor: ColorConstants.primaryColor,
      expansionTileTheme:
          ExpansionTileThemeData(iconColor: ColorConstants.primaryColor),
      scaffoldBackgroundColor: ColorConstants.scaffoldBackgroundColorL,
      fontFamily: 'Poppins',
      iconTheme: const IconThemeData(size: 20, color: Colors.black),
      textTheme: lightTextTheme,
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            side: MaterialStateProperty.all(
              BorderSide(color: Colors.green.shade100),
            ),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.green.shade600),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)))),
      ),
     
      textSelectionTheme:
          TextSelectionThemeData(cursorColor: ColorConstants.primaryColor),
    );
  }
}
