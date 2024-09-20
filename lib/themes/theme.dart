import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // primary and secondary colors
  static const Color primaryColor = Color(0xFF006B83);
  static const Color secondaryColor = Color(0xFF5000B9);

  // text styles
  static TextStyle textStyle1 = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle textStyle2 = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle textStyle3 = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle textStyle4 = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
  );

  static TextStyle textStyle5 = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // theme data
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: GoogleFonts.publicSans().fontFamily,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
      ),
      scaffoldBackgroundColor: Colors.white,
      
      textTheme: TextTheme(
        bodyLarge: textStyle1,
        bodyMedium: textStyle2,
        bodySmall: textStyle3,
        titleMedium: textStyle4,
        titleSmall: textStyle5,
      ),
    );
  }
}
