import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:google_fonts/google_fonts.dart';

class MingleTheme {
  static ThemeData lightTheme() => ThemeData(
        brightness: Brightness.light,
        fontFamily: GoogleFonts.ubuntu().fontFamily,
      );

  static ThemeData DarkTheme() => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: navyblueshade2,
        fontFamily: GoogleFonts.ubuntu().fontFamily,
        iconTheme: const IconThemeData(color: Colors.white),
        accentColor: navyblueshade3,
        appBarTheme: AppBarTheme(
          backgroundColor: navyblueshade2,
          iconTheme: const IconThemeData(color: Colors.white),
          actionsIconTheme: const IconThemeData(color: Colors.white),
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: navyblueshade4,
        ),
      );

  static Color navyblueshade1 = HexColor('#1C223A');
  static Color navyblueshade2 = HexColor('#1E233E');
  static Color navyblueshade3 = HexColor('#161A2C');
  static Color navyblueshade4 = HexColor('#20263F');
  static Color whiteShade1 = HexColor('#C7D8EB');
  static Color lightBlueShade = HexColor('#87A5B9');
}
