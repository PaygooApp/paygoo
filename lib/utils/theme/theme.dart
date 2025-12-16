import 'package:flutter/material.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';
import 'package:paygoo/utils/theme/custom_theme/appbar_theme.dart';
import 'package:paygoo/utils/theme/custom_theme/bottom_sheet_theme.dart';
import 'package:paygoo/utils/theme/custom_theme/elevated_button_theme.dart';
import 'package:paygoo/utils/theme/custom_theme/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  // Light ColorScheme using tokens
  static final ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    // Primary
    primary: TokenPrimitiveMode1.primary500,
    onPrimary: TokenPrimitiveMode1.basewhite,
    primaryContainer: TokenPrimitiveMode1.primary100,
    onPrimaryContainer: TokenPrimitiveMode1.primary900,
    // Secondary (using primary as secondary for now)
    secondary: TokenPrimitiveMode1.primary400,
    onSecondary: TokenPrimitiveMode1.basewhite,
    secondaryContainer: TokenPrimitiveMode1.primary50,
    onSecondaryContainer: TokenPrimitiveMode1.primary800,
    // Tertiary (using info colors)
    tertiary: TokenPrimitiveMode1.accentinfo500,
    onTertiary: TokenPrimitiveMode1.basewhite,
    tertiaryContainer: TokenPrimitiveMode1.accentinfo100,
    onTertiaryContainer: TokenPrimitiveMode1.accentinfo900,
    // Error
    error: TokenPrimitiveMode1.accenterror500,
    onError: TokenPrimitiveMode1.basewhite,
    errorContainer: TokenPrimitiveMode1.accenterror100,
    onErrorContainer: TokenPrimitiveMode1.accenterror900,
    // Surface
    surface: TokenPrimitiveMode1.basewhite,
    onSurface: TokenPrimitiveMode1.gray900,
    surfaceContainerHighest: TokenPrimitiveMode1.gray100,
    onSurfaceVariant: TokenPrimitiveMode1.gray600,
    // Outline
    outline: TokenPrimitiveMode1.gray300,
    outlineVariant: TokenPrimitiveMode1.gray200,
    // Shadow & Scrim
    shadow: TokenPrimitiveMode1.baseblack,
    scrim: TokenPrimitiveMode1.baseblack,
    // Inverse
    inverseSurface: TokenPrimitiveMode1.gray900,
    onInverseSurface: TokenPrimitiveMode1.gray50,
    inversePrimary: TokenPrimitiveMode1.primary200,
  );

  // Dark ColorScheme using tokens
  static final ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    // Primary
    primary: TokenPrimitiveMode1.primary400,
    onPrimary: TokenPrimitiveMode1.primary950,
    primaryContainer: TokenPrimitiveMode1.primary800,
    onPrimaryContainer: TokenPrimitiveMode1.primary100,
    // Secondary
    secondary: TokenPrimitiveMode1.primary300,
    onSecondary: TokenPrimitiveMode1.primary950,
    secondaryContainer: TokenPrimitiveMode1.primary700,
    onSecondaryContainer: TokenPrimitiveMode1.primary50,
    // Tertiary (using info colors)
    tertiary: TokenPrimitiveMode1.accentinfo400,
    onTertiary: TokenPrimitiveMode1.accentinfo950,
    tertiaryContainer: TokenPrimitiveMode1.accentinfo800,
    onTertiaryContainer: TokenPrimitiveMode1.accentinfo100,
    // Error
    error: TokenPrimitiveMode1.accenterror400,
    onError: TokenPrimitiveMode1.accenterror950,
    errorContainer: TokenPrimitiveMode1.accenterror800,
    onErrorContainer: TokenPrimitiveMode1.accenterror100,
    // Surface
    surface: TokenPrimitiveMode1.gray950,
    onSurface: TokenPrimitiveMode1.gray50,
    surfaceContainerHighest: TokenPrimitiveMode1.gray800,
    onSurfaceVariant: TokenPrimitiveMode1.gray400,
    // Outline
    outline: TokenPrimitiveMode1.gray600,
    outlineVariant: TokenPrimitiveMode1.gray700,
    // Shadow & Scrim
    shadow: TokenPrimitiveMode1.baseblack,
    scrim: TokenPrimitiveMode1.baseblack,
    // Inverse
    inverseSurface: TokenPrimitiveMode1.gray100,
    onInverseSurface: TokenPrimitiveMode1.gray900,
    inversePrimary: TokenPrimitiveMode1.primary700,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: lightColorScheme,
    primaryColor: TokenPrimitiveMode1.primary500,
    scaffoldBackgroundColor: TokenPrimitiveMode1.basewhite,
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    dividerColor: TokenPrimitiveMode1.gray200,
    disabledColor: TokenPrimitiveMode1.gray400,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: darkColorScheme,
    primaryColor: TokenPrimitiveMode1.primary400,
    scaffoldBackgroundColor: TokenPrimitiveMode1.gray950,
    textTheme: TTextTheme.darkTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    dividerColor: TokenPrimitiveMode1.gray700,
    disabledColor: TokenPrimitiveMode1.gray600,
  );
}
