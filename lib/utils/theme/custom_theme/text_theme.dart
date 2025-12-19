import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

class TTextTheme {
  TTextTheme._();

  // Title font (Inter) - for headlines and titles
  static TextStyle _titleStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required double lineHeight,
    required Color color,
    double? letterSpacing,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: lineHeight / fontSize,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  // Body font (DM Sans) - for body text and labels
  static TextStyle _bodyStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required double lineHeight,
    required Color color,
    double? letterSpacing,
  }) {
    return GoogleFonts.dmSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: lineHeight / fontSize,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: _titleStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlexl.toDouble(),
      fontWeight: FontWeight.w700,
      lineHeight: TokenPrimitiveMode1.typographylineHeightheadingxl.toDouble(),
      color: TokenPrimitiveMode1.gray900,
      letterSpacing: -0.5,
    ),
    headlineMedium: _titleStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlelg.toDouble(),
      fontWeight: FontWeight.w700,
      lineHeight: TokenPrimitiveMode1.typographylineHeightheadinglg.toDouble(),
      color: TokenPrimitiveMode1.gray900,
      letterSpacing: -0.5,
    ),
    headlineSmall: _titleStyle(
      fontSize: TokenPrimitiveMode1.typographylineHeightbodyxs.toDouble(),
      fontWeight: FontWeight.w700,
      lineHeight: TokenPrimitiveMode1.typographylineHeightheadingsm.toDouble(),
      color: TokenPrimitiveMode1.gray900,
      letterSpacing: -0.5,
    ),
    titleLarge: _titleStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlelg.toDouble(),
      fontWeight: FontWeight.w600,
      lineHeight: TokenPrimitiveMode1.typographylineHeightheadinglg.toDouble(),
      color: TokenPrimitiveMode1.gray900,
    ),
    titleMedium: _titleStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlemd.toDouble(),
      fontWeight: FontWeight.w500,
      lineHeight: TokenPrimitiveMode1.typographylineHeightheadingmd.toDouble(),
      color: TokenPrimitiveMode1.gray900,
    ),
    titleSmall: _titleStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlesm.toDouble(),
      fontWeight: FontWeight.w400,
      lineHeight: TokenPrimitiveMode1.typographylineHeightheadingsm.toDouble(),
      color: TokenPrimitiveMode1.gray900,
    ),
    bodyLarge: _bodyStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizebodylg.toDouble(),
      fontWeight: FontWeight.w500,
      lineHeight: TokenPrimitiveMode1.typographylineHeightbodylg.toDouble(),
      color: TokenPrimitiveMode1.gray900,
    ),
    bodyMedium: _bodyStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizebodysm.toDouble(),
      fontWeight: FontWeight.w500,
      lineHeight: TokenPrimitiveMode1.typographylineHeightbodyxs.toDouble(),
      color: TokenPrimitiveMode1.gray900,
      letterSpacing: -0.5,
    ),
    bodySmall: _bodyStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizebodymd.toDouble(),
      fontWeight: FontWeight.w400,
      lineHeight: TokenPrimitiveMode1.typographylineHeightbodysm.toDouble(),
      color: TokenPrimitiveMode1.gray500,
    ),
    labelLarge: _bodyStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizebodyxs.toDouble(),
      fontWeight: FontWeight.w400,
      lineHeight: TokenPrimitiveMode1.typographylineHeightbodyxs.toDouble(),
      color: TokenPrimitiveMode1.gray900,
    ),
    labelMedium: _bodyStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizebodyxs.toDouble(),
      fontWeight: FontWeight.w400,
      lineHeight: TokenPrimitiveMode1.typographylineHeightbodyxs.toDouble(),
      color: TokenPrimitiveMode1.gray600,
    ),
  );

  /// Customizable Dark Text Theme
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: _titleStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlexl.toDouble(),
      fontWeight: FontWeight.w700,
      lineHeight: TokenPrimitiveMode1.typographylineHeightheadingxl.toDouble(),
      color: TokenPrimitiveMode1.basewhite,
      letterSpacing: -0.5,
    ),
    headlineMedium: _titleStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlelg.toDouble(),
      fontWeight: FontWeight.w700,
      lineHeight: TokenPrimitiveMode1.typographylineHeightheadinglg.toDouble(),
      color: TokenPrimitiveMode1.basewhite,
      letterSpacing: -0.5,
    ),
    headlineSmall: _titleStyle(
      fontSize: TokenPrimitiveMode1.typographylineHeightbodyxs.toDouble(),
      fontWeight: FontWeight.w700,
      lineHeight: TokenPrimitiveMode1.typographylineHeightheadingsm.toDouble(),
      color: TokenPrimitiveMode1.basewhite,
      letterSpacing: -0.5,
    ),
    titleLarge: _titleStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlelg.toDouble(),
      fontWeight: FontWeight.w600,
      lineHeight: TokenPrimitiveMode1.typographylineHeightheadinglg.toDouble(),
      color: TokenPrimitiveMode1.basewhite,
    ),
    titleMedium: _titleStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlemd.toDouble(),
      fontWeight: FontWeight.w500,
      lineHeight: TokenPrimitiveMode1.typographylineHeightheadingmd.toDouble(),
      color: TokenPrimitiveMode1.basewhite,
    ),
    titleSmall: _titleStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlesm.toDouble(),
      fontWeight: FontWeight.w400,
      lineHeight: TokenPrimitiveMode1.typographylineHeightheadingsm.toDouble(),
      color: TokenPrimitiveMode1.basewhite,
    ),
    bodyLarge: _bodyStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizebodylg.toDouble(),
      fontWeight: FontWeight.w500,
      lineHeight: TokenPrimitiveMode1.typographylineHeightbodylg.toDouble(),
      color: TokenPrimitiveMode1.basewhite,
    ),
    bodyMedium: _bodyStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizebodysm.toDouble(),
      fontWeight: FontWeight.w500,
      lineHeight: TokenPrimitiveMode1.typographylineHeightbodyxs.toDouble(),
      color: TokenPrimitiveMode1.basewhite,
      letterSpacing: -0.5,
    ),
    bodySmall: _bodyStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizebodymd.toDouble(),
      fontWeight: FontWeight.w400,
      lineHeight: TokenPrimitiveMode1.typographylineHeightbodysm.toDouble(),
      color: TokenPrimitiveMode1.gray400,
    ),
    labelLarge: _bodyStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizebodyxs.toDouble(),
      fontWeight: FontWeight.w400,
      lineHeight: TokenPrimitiveMode1.typographylineHeightbodyxs.toDouble(),
      color: TokenPrimitiveMode1.basewhite,
    ),
    labelMedium: _bodyStyle(
      fontSize: TokenPrimitiveMode1.typographyfontSizebodyxs.toDouble(),
      fontWeight: FontWeight.w400,
      lineHeight: TokenPrimitiveMode1.typographylineHeightbodyxs.toDouble(),
      color: TokenPrimitiveMode1.gray400,
    ),
  );
}
