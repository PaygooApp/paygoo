import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  /// -- Light Theme
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: TokenPrimitiveMode1.basewhite,
      backgroundColor: TokenPrimitiveMode1.primary500,
      disabledForegroundColor: TokenPrimitiveMode1.gray400,
      disabledBackgroundColor: TokenPrimitiveMode1.gray200,
      side: const BorderSide(color: TokenPrimitiveMode1.primary500),
      padding: EdgeInsets.symmetric(
        vertical: TokenPrimitiveMode1.scale500.toDouble(),
      ),
      textStyle: GoogleFonts.dmSans(
        fontSize: TokenPrimitiveMode1.typographyfontSizebodylg.toDouble(),
        color: TokenPrimitiveMode1.basewhite,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          TokenPrimitiveMode1.borderRadiusmd.toDouble(),
        ),
      ),
    ),
  );

  /// -- Dark Theme
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: TokenPrimitiveMode1.basewhite,
      backgroundColor: TokenPrimitiveMode1.primary500,
      disabledForegroundColor: TokenPrimitiveMode1.gray600,
      disabledBackgroundColor: TokenPrimitiveMode1.gray800,
      side: const BorderSide(color: TokenPrimitiveMode1.primary500),
      padding: EdgeInsets.symmetric(
        vertical: TokenPrimitiveMode1.scale500.toDouble(),
      ),
      textStyle: GoogleFonts.dmSans(
        fontSize: TokenPrimitiveMode1.typographyfontSizebodylg.toDouble(),
        color: TokenPrimitiveMode1.basewhite,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          TokenPrimitiveMode1.borderRadiusmd.toDouble(),
        ),
      ),
    ),
  );
}
