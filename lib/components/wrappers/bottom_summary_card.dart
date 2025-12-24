import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paygoo/components/atoms/option_card_selector.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';
import 'package:sliding_action_button/sliding_action_button.dart';

/// A fixed bottom card that displays order summary information.
class BottomSummaryCard extends StatelessWidget {
  final double selectedItemsTotal;
  final String initialSlideText;
  final String completedSlideText;
  final VoidCallback? onSlideCompleted;
  final bool isEnabled;
  final int? selectedTipIndex;
  final ValueChanged<int?>? onTipChanged;
  final double? customTipPercentage;
  final VoidCallback? onCustomTipTapped;

  const BottomSummaryCard({
    super.key,
    this.selectedItemsTotal = 0.0,
    this.initialSlideText = "Slide to Pay",
    this.completedSlideText = "Processing...",
    this.onSlideCompleted,
    this.isEnabled = true,
    this.selectedTipIndex,
    this.onTipChanged,
    this.customTipPercentage,
    this.onCustomTipTapped,
  });

  // Tip options for the selector
  static const List<OptionCardItem> tipOptions = [
    OptionCardItem(emoji: '😎', label: '5%', value: 5),
    OptionCardItem(emoji: '🎉', label: '10%', value: 10),
    OptionCardItem(emoji: '🔥', label: '15%', value: 15),
    OptionCardItem(
      emoji: '✏️',
      label: 'Custom',
      value: -1,
    ), // -1 indicates custom
  ];

  double get _tipAmount {
    if (selectedTipIndex == null) return 0.0;
    final option = tipOptions[selectedTipIndex!];
    // Custom tip: use customTipPercentage
    if (option.value == -1) {
      return selectedItemsTotal * (customTipPercentage ?? 0) / 100;
    }
    return selectedItemsTotal * (option.value as int) / 100;
  }

  double get _totalAmount => selectedItemsTotal + _tipAmount;

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  /// Build tip options with dynamic custom label
  List<OptionCardItem> _buildTipOptions() {
    return [
      const OptionCardItem(emoji: '😎', label: '5%', value: 5),
      const OptionCardItem(emoji: '🎉', label: '10%', value: 10),
      const OptionCardItem(emoji: '🔥', label: '15%', value: 15),
      OptionCardItem(
        emoji: '✏️',
        label: customTipPercentage != null
            ? '${customTipPercentage!.round()}%'
            : 'Custom',
        value: -1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(color: TokenPrimitiveMode1.gray100, width: 1),
          left: BorderSide(color: TokenPrimitiveMode1.gray100, width: 1),
          right: BorderSide(color: TokenPrimitiveMode1.gray100, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, -8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tip and Service Fee rows - only show when items are selected
              if (isEnabled) ...[
                // Tip label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Add tips ",
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: TokenPrimitiveMode1.gray900,
                          ),
                        ),
                        TextSpan(
                          text: "(optional)",
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: TokenPrimitiveMode1.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Tip selector cards
                OptionCardSelector(
                  options: _buildTipOptions(),
                  selectedIndex: selectedTipIndex,
                  onChanged: (index) {
                    // If Custom is tapped, only trigger modal (don't select yet)
                    if (index == 3) {
                      onCustomTipTapped?.call();
                      return; // Don't call onTipChanged - modal will handle it
                    }
                    onTipChanged?.call(index);
                  },
                ),
                const SizedBox(height: 12),
                // Service Fee row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Service Fee",
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: TokenPrimitiveMode1.gray500,
                      ),
                    ),
                    Text(
                      _formatCurrency(selectedItemsTotal),
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: TokenPrimitiveMode1.gray700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Tip amount row (only show if tip selected)
                if (selectedTipIndex != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tip Amount",
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: TokenPrimitiveMode1.gray500,
                        ),
                      ),
                      Text(
                        _formatCurrency(_tipAmount),
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: TokenPrimitiveMode1.gray700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ],
              // Sliding action button with checkmark indicator
              SizedBox(
                height: 64,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleSlideToActionButton(
                        // Width accounts for checkmark circle on right
                        width: MediaQuery.of(context).size.width - 40,
                        height: 50,
                        parentBoxRadiusValue: 50,
                        circleSlidingButtonSize: 50,
                        initialSlidingActionLabel:
                            'Swipe to pay ${_formatCurrency(_totalAmount)}',
                        finalSlidingActionLabel: 'Processing...',
                        initialSlidingActionLabelTextStyle: GoogleFonts.dmSans(
                          fontSize: TokenPrimitiveMode1.typographyfontSizebodylg
                              .toDouble(),
                          fontWeight: FontWeight.w600,
                          color: TokenPrimitiveMode1.gray800,
                        ),
                        finalSlidingActionLabelTextStyle: GoogleFonts.dmSans(
                          fontSize: TokenPrimitiveMode1.typographyfontSizebodylg
                              .toDouble(),
                          fontWeight: FontWeight.w600,
                          color: TokenPrimitiveMode1.gray800,
                        ),
                        circleSlidingButtonIcon: const Icon(
                          Icons.keyboard_double_arrow_right_outlined,
                          color: TokenPrimitiveMode1.basewhite,
                        ),
                        parentBoxBackgroundColor: TokenPrimitiveMode1.primary50,
                        parentBoxDisableBackgroundColor: Colors.grey,
                        circleSlidingButtonBackgroundColor:
                            TokenPrimitiveMode1.primary500,
                        isEnable: true,
                        onSlideActionCompleted: () {
                          print("Sliding action completed");
                        },
                        onSlideActionCanceled: () {
                          print("Sliding action cancelled");
                        },
                      ),
                      // Checkmark circle on the right
                      Positioned(
                        right: 0,
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: TokenPrimitiveMode1.basewhite,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: TokenPrimitiveMode1.gray100,
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: TokenPrimitiveMode1.baseblack,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // const SizedBox(height: 12),
              // Terms and conditions text
              // Center(
              //   child: RichText(
              //     textAlign: TextAlign.center,
              //     text: TextSpan(
              //       style: GoogleFonts.dmSans(
              //         fontSize: 10,
              //         color: TokenPrimitiveMode1.gray400,
              //       ),
              //       children: [
              //         const TextSpan(text: 'By proceeding you agree to our '),
              //         TextSpan(
              //           text: 'Terms & Conditions',
              //           style: GoogleFonts.dmSans(
              //             fontSize: 10,
              //             fontWeight: FontWeight.w600,
              //             color: TokenPrimitiveMode1.primary500,
              //           ),
              //         ),
              //         const TextSpan(text: '\nand '),
              //         TextSpan(
              //           text: 'Privacy Policy',
              //           style: GoogleFonts.dmSans(
              //             fontSize: 10,
              //             fontWeight: FontWeight.w600,
              //             color: TokenPrimitiveMode1.primary500,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
