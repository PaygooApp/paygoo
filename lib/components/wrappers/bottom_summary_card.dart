import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';
import 'package:sliding_action_button/sliding_action_button.dart';

/// A fixed bottom card that displays order summary information.
class BottomSummaryCard extends StatelessWidget {
  final String selectedItemsAmount;
  final String tipAmount;
  final String totalAmount;
  final String initialSlideText;
  final String completedSlideText;
  final VoidCallback? onSlideCompleted;
  final bool isEnabled;

  const BottomSummaryCard({
    super.key,
    this.selectedItemsAmount = "\$0.00",
    this.tipAmount = "\$0.00",
    this.totalAmount = "\$0.00",
    this.initialSlideText = "Slide to Pay",
    this.completedSlideText = "Processing...",
    this.onSlideCompleted,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
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
              // Selected Items row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Selected Items",
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: TokenPrimitiveMode1.gray500,
                    ),
                  ),
                  Text(
                    selectedItemsAmount,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: TokenPrimitiveMode1.gray700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Tip row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tip",
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: TokenPrimitiveMode1.gray500,
                    ),
                  ),
                  Text(
                    tipAmount,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: TokenPrimitiveMode1.gray700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Horizontal divider
              Divider(
                height: 1,
                thickness: 1,
                color: TokenPrimitiveMode1.gray200,
              ),
              const SizedBox(height: 12),
              // Total row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: TokenPrimitiveMode1.gray700,
                    ),
                  ),
                  Text(
                    totalAmount,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Sliding action button with oversized thumb
              SizedBox(
                height: 64, // Extra height to accommodate larger button
                child: Center(
                  child: CircleSlideToActionButton(
                    // Full width of card (screen width - horizontal padding 20*2)
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    parentBoxRadiusValue: 50,
                    circleSlidingButtonSize: 50,
                    initialSlidingActionLabel: 'Tap to add more items',
                    finalSlidingActionLabel: 'Added To Basket',
                    initialSlidingActionLabelTextStyle: GoogleFonts.dmSans(
                      fontSize: TokenPrimitiveMode1.typographyfontSizebodylg
                          .toDouble(),
                      fontWeight: FontWeight.w600,
                      color: TokenPrimitiveMode1.gray400,
                    ),
                    finalSlidingActionLabelTextStyle: GoogleFonts.dmSans(
                      fontSize: TokenPrimitiveMode1.typographyfontSizebodylg
                          .toDouble(),
                      fontWeight: FontWeight.w600,
                      color: TokenPrimitiveMode1.gray500,
                    ),
                    circleSlidingButtonIcon: const Icon(
                      Icons.keyboard_double_arrow_right_outlined,
                      color: TokenPrimitiveMode1.basewhite,
                    ),
                    parentBoxBackgroundColor: TokenPrimitiveMode1.primary50,
                    parentBoxDisableBackgroundColor: Colors.grey,
                    /*  parentBoxGradientBackgroundColor:
                  LinearGradient(colors: [Colors.red, Colors.white]),
              parentBoxDisableGradientBackgroundColor:
                  LinearGradient(colors: [Colors.red, Colors.white]),*/
                    circleSlidingButtonBackgroundColor: TokenPrimitiveMode1
                        .primary500
                        .withValues(alpha: 0.28),
                    isEnable: true,
                    onSlideActionCompleted: () {
                      print("Sliding action completed");
                    },
                    onSlideActionCanceled: () {
                      print("Sliding action cancelled");
                    },
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
