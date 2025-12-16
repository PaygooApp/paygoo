import 'package:flutter/material.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static final lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(
      color: TokenPrimitiveMode1.gray900,
      size: TokenPrimitiveMode1.scale600.toDouble(),
    ),
    actionsIconTheme: IconThemeData(
      color: TokenPrimitiveMode1.gray900,
      size: TokenPrimitiveMode1.scale600.toDouble(),
    ),
    titleTextStyle: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilytitle,
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlemd.toDouble(),
      fontWeight: FontWeight.w600,
      color: TokenPrimitiveMode1.gray900,
    ),
  );

  static final darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(
      color: TokenPrimitiveMode1.basewhite,
      size: TokenPrimitiveMode1.scale600.toDouble(),
    ),
    actionsIconTheme: IconThemeData(
      color: TokenPrimitiveMode1.basewhite,
      size: TokenPrimitiveMode1.scale600.toDouble(),
    ),
    titleTextStyle: TextStyle(
      fontFamily: TokenPrimitiveMode1.typographyfontFamilytitle,
      fontSize: TokenPrimitiveMode1.typographyfontSizetitlemd.toDouble(),
      fontWeight: FontWeight.w600,
      color: TokenPrimitiveMode1.basewhite,
    ),
  );
}
