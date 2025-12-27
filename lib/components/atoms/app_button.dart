import 'package:flutter/material.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// Button style variants
enum AppButtonStyle {
  /// Primary button (green background, white text)
  primary,

  /// Secondary button (gray background, dark text)
  secondary,
}

/// A reusable rounded button component
class AppButton extends StatelessWidget {
  /// Button text
  final String text;

  /// Callback when button is pressed
  final VoidCallback onPressed;

  /// Button style (primary or secondary)
  final AppButtonStyle style;

  /// Whether the button should expand to fill available width
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style = AppButtonStyle.primary,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSecondary = style == AppButtonStyle.secondary;

    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSecondary
            ? TokenPrimitiveMode1.gray100
            : TokenPrimitiveMode1.primary400,
        foregroundColor: isSecondary
            ? TokenPrimitiveMode1.gray700
            : TokenPrimitiveMode1.basewhite,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          color: isSecondary
              ? TokenPrimitiveMode1.gray700
              : TokenPrimitiveMode1.basewhite,
        ),
      ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
