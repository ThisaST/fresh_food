import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme(),
  primaryColorDark: const Color(0xff489100),
  primaryColorLight: const Color(0xffedf4e5),
  primaryColor: const Color(0xff489100),
  colorScheme: const ColorScheme.light(secondary: Color(0xFF009688)),
  scaffoldBackgroundColor: Colors.white,
  canvasColor: const Color(0xffffffff), // White
  // cardColor: const Color(0xffe2e4e8), // Card background color
  cardColor: const Color(0xffedf4e5),
  shadowColor: const Color(0xffe2e4e8),
  secondaryHeaderColor: const Color(0xfff6a600), // Dark yellow
  dividerColor: const Color(0xff828d9f), // Grey color
  inputDecorationTheme: InputDecorationTheme(
    focusColor: const Color(0xff489100),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);

// f6a600