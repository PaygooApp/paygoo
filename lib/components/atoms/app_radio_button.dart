import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// A custom radio button with a small white circle inside when selected.
class AppRadioButton extends StatelessWidget {
  const AppRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.size = 24,
    this.innerCircleSize = 10,
    this.borderWidth = 2,
  });

  /// The value represented by this radio button.
  final int value;

  /// The currently selected value for the group.
  final int groupValue;

  /// Called when the user selects this radio button.
  final ValueChanged<int>? onChanged;

  /// The size of the radio button (default: 24).
  final double size;

  /// The size of the inner white circle when selected (default: 10).
  final double innerCircleSize;

  /// The width of the border (default: 2).
  final double borderWidth;

  bool get _isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null
          ? () {
              HapticFeedback.lightImpact();
              onChanged!(value);
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _isSelected
              ? Theme.of(context).colorScheme.secondary
              : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: _isSelected
                ? Theme.of(context).colorScheme.secondary
                : TokenPrimitiveMode1.gray400,
            width: borderWidth,
          ),
        ),
        child: _isSelected
            ? Center(
                child: Container(
                  width: innerCircleSize,
                  height: innerCircleSize,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
