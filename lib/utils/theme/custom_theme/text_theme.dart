import 'package:flutter/material.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilytitle,
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlexl.toDouble(),
      fontWeight: FontWeight.w700,
      height:
          TokenPrimitiveMode1.typographylineHeightheadingxl /
          TokenPrimitiveMode1.typographyfontSizetitlexl,
      color: TokenPrimitiveMode1.gray900,
    ),
    headlineMedium: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilytitle,
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlelg.toDouble(),
      fontWeight: FontWeight.w600,
      height:
          TokenPrimitiveMode1.typographylineHeightheadinglg /
          TokenPrimitiveMode1.typographyfontSizetitlelg,
      color: TokenPrimitiveMode1.gray900,
    ),
    headlineSmall: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilytitle,
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlemd.toDouble(),
      fontWeight: FontWeight.w600,
      height:
          TokenPrimitiveMode1.typographylineHeightheadingmd /
          TokenPrimitiveMode1.typographyfontSizetitlemd,
      color: TokenPrimitiveMode1.gray900,
    ),
    titleLarge: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilytitle,
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlesm.toDouble(),
      fontWeight: FontWeight.w600,
      height:
          TokenPrimitiveMode1.typographylineHeightheadingsm /
          TokenPrimitiveMode1.typographyfontSizetitlesm,
      color: TokenPrimitiveMode1.gray900,
    ),
    titleMedium: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilytitle,
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlesm.toDouble(),
      fontWeight: FontWeight.w500,
      height:
          TokenPrimitiveMode1.typographylineHeightheadingsm /
          TokenPrimitiveMode1.typographyfontSizetitlesm,
      color: TokenPrimitiveMode1.gray900,
    ),
    titleSmall: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilytitle,
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlexs.toDouble(),
      fontWeight: FontWeight.w400,
      height:
          TokenPrimitiveMode1.typographylineHeightheadingxs /
          TokenPrimitiveMode1.typographyfontSizetitlexs,
      color: TokenPrimitiveMode1.gray900,
    ),
    bodyLarge: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilybody,
      fontSize: TokenPrimitiveMode1.typographyfontSizebodylg.toDouble(),
      fontWeight: FontWeight.w500,
      height:
          TokenPrimitiveMode1.typographylineHeightbodylg /
          TokenPrimitiveMode1.typographyfontSizebodylg,
      color: TokenPrimitiveMode1.gray900,
    ),
    bodyMedium: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilybody,
      fontSize: TokenPrimitiveMode1.typographyfontSizebodysm.toDouble(),
      fontWeight: FontWeight.w400,
      height:
          TokenPrimitiveMode1.typographylineHeightbodysm /
          TokenPrimitiveMode1.typographyfontSizebodysm,
      color: TokenPrimitiveMode1.gray900,
    ),
    bodySmall: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilybody,
      fontSize: TokenPrimitiveMode1.typographyfontSizebodymd.toDouble(),
      fontWeight: FontWeight.w500,
      height:
          TokenPrimitiveMode1.typographylineHeightbodymd /
          TokenPrimitiveMode1.typographyfontSizebodymd,
      color: TokenPrimitiveMode1.gray600,
    ),
    labelLarge: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilybody,
      fontSize: TokenPrimitiveMode1.typographyfontSizebodyxs.toDouble(),
      fontWeight: FontWeight.w400,
      height:
          TokenPrimitiveMode1.typographylineHeightbodyxs /
          TokenPrimitiveMode1.typographyfontSizebodyxs,
      color: TokenPrimitiveMode1.gray900,
    ),
    labelMedium: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilybody,
      fontSize: TokenPrimitiveMode1.typographyfontSizebodyxs.toDouble(),
      fontWeight: FontWeight.w400,
      height:
          TokenPrimitiveMode1.typographylineHeightbodyxs /
          TokenPrimitiveMode1.typographyfontSizebodyxs,
      color: TokenPrimitiveMode1.gray600,
    ),
  );

  /// Customizable Dark Text Theme
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilytitle,
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlexl.toDouble(),
      fontWeight: FontWeight.w700,
      height:
          TokenPrimitiveMode1.typographylineHeightheadingxl /
          TokenPrimitiveMode1.typographyfontSizetitlexl,
      color: TokenPrimitiveMode1.basewhite,
    ),
    headlineMedium: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilytitle,
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlelg.toDouble(),
      fontWeight: FontWeight.w600,
      height:
          TokenPrimitiveMode1.typographylineHeightheadinglg /
          TokenPrimitiveMode1.typographyfontSizetitlelg,
      color: TokenPrimitiveMode1.basewhite,
    ),
    headlineSmall: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilytitle,
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlemd.toDouble(),
      fontWeight: FontWeight.w600,
      height:
          TokenPrimitiveMode1.typographylineHeightheadingmd /
          TokenPrimitiveMode1.typographyfontSizetitlemd,
      color: TokenPrimitiveMode1.basewhite,
    ),
    titleLarge: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilytitle,
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlesm.toDouble(),
      fontWeight: FontWeight.w600,
      height:
          TokenPrimitiveMode1.typographylineHeightheadingsm /
          TokenPrimitiveMode1.typographyfontSizetitlesm,
      color: TokenPrimitiveMode1.basewhite,
    ),
    titleMedium: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilytitle,
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlesm.toDouble(),
      fontWeight: FontWeight.w500,
      height:
          TokenPrimitiveMode1.typographylineHeightheadingsm /
          TokenPrimitiveMode1.typographyfontSizetitlesm,
      color: TokenPrimitiveMode1.basewhite,
    ),
    titleSmall: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilytitle,
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlexs.toDouble(),
      fontWeight: FontWeight.w400,
      height:
          TokenPrimitiveMode1.typographylineHeightheadingxs /
          TokenPrimitiveMode1.typographyfontSizetitlexs,
      color: TokenPrimitiveMode1.basewhite,
    ),
    bodyLarge: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilybody,
      fontSize: TokenPrimitiveMode1.typographyfontSizebodylg.toDouble(),
      fontWeight: FontWeight.w500,
      height:
          TokenPrimitiveMode1.typographylineHeightbodylg /
          TokenPrimitiveMode1.typographyfontSizebodylg,
      color: TokenPrimitiveMode1.basewhite,
    ),
    bodyMedium: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilybody,
      fontSize: TokenPrimitiveMode1.typographyfontSizebodysm.toDouble(),
      fontWeight: FontWeight.w400,
      height:
          TokenPrimitiveMode1.typographylineHeightbodysm /
          TokenPrimitiveMode1.typographyfontSizebodysm,
      color: TokenPrimitiveMode1.basewhite,
    ),
    bodySmall: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilybody,
      fontSize: TokenPrimitiveMode1.typographyfontSizebodymd.toDouble(),
      fontWeight: FontWeight.w500,
      height:
          TokenPrimitiveMode1.typographylineHeightbodymd /
          TokenPrimitiveMode1.typographyfontSizebodymd,
      color: TokenPrimitiveMode1.gray400,
    ),
    labelLarge: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilybody,
      fontSize: TokenPrimitiveMode1.typographyfontSizebodyxs.toDouble(),
      fontWeight: FontWeight.w400,
      height:
          TokenPrimitiveMode1.typographylineHeightbodyxs /
          TokenPrimitiveMode1.typographyfontSizebodyxs,
      color: TokenPrimitiveMode1.basewhite,
    ),
    labelMedium: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilybody,
      fontSize: TokenPrimitiveMode1.typographyfontSizebodyxs.toDouble(),
      fontWeight: FontWeight.w400,
      height:
          TokenPrimitiveMode1.typographylineHeightbodyxs /
          TokenPrimitiveMode1.typographyfontSizebodyxs,
      color: TokenPrimitiveMode1.gray400,
    ),
  );
}
