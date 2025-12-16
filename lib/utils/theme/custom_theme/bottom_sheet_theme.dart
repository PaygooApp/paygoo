import 'package:flutter/material.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

class TBottomSheetTheme {
  TBottomSheetTheme._();

  static BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: TokenPrimitiveMode1.basewhite,
    modalBackgroundColor: TokenPrimitiveMode1.basewhite,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        TokenPrimitiveMode1.borderRadiuslg.toDouble(),
      ),
    ),
  );

  static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: TokenPrimitiveMode1.gray950,
    modalBackgroundColor: TokenPrimitiveMode1.gray950,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        TokenPrimitiveMode1.borderRadiuslg.toDouble(),
      ),
    ),
  );
}
