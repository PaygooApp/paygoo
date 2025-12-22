import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// Represents a single option in the selector
class OptionCardItem {
  final String emoji;
  final String label;
  final dynamic value;

  const OptionCardItem({required this.emoji, required this.label, this.value});
}

/// A horizontal row of selectable option cards with emoji and label.
/// Commonly used for tip selection, ratings, or any multi-choice selector.
class OptionCardSelector extends StatelessWidget {
  /// List of options to display
  final List<OptionCardItem> options;

  /// Currently selected index (null if none selected)
  final int? selectedIndex;

  /// Callback when selection changes
  final ValueChanged<int?>? onChanged;

  /// Gap between cards
  final double gap;

  /// Vertical padding inside each card
  final double verticalPadding;

  /// Border radius of each card
  final double borderRadius;

  /// Emoji font size
  final double emojiFontSize;

  /// Label font size
  final double labelFontSize;

  /// Whether tapping the selected card deselects it
  final bool allowDeselect;

  const OptionCardSelector({
    super.key,
    required this.options,
    this.selectedIndex,
    this.onChanged,
    this.gap = 8,
    this.verticalPadding = 12,
    this.borderRadius = 12,
    this.emojiFontSize = 16,
    this.labelFontSize = 13,
    this.allowDeselect = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(options.length, (index) {
        final option = options[index];
        final isSelected = selectedIndex == index;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              if (allowDeselect && selectedIndex == index) {
                onChanged?.call(null);
              } else {
                onChanged?.call(index);
              }
            },
            child: Container(
              margin: EdgeInsets.only(
                right: index < options.length - 1 ? gap : 0,
              ),
              padding: EdgeInsets.symmetric(vertical: verticalPadding),
              decoration: BoxDecoration(
                color: isSelected
                    ? TokenPrimitiveMode1.primary50
                    : TokenPrimitiveMode1.gray50,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: isSelected
                      ? TokenPrimitiveMode1.primary500
                      : TokenPrimitiveMode1.gray100,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(option.emoji, style: TextStyle(fontSize: emojiFontSize)),
                  const SizedBox(width: 4),
                  Text(
                    option.label,
                    style: GoogleFonts.dmSans(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? TokenPrimitiveMode1.primary500
                          : TokenPrimitiveMode1.gray500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
