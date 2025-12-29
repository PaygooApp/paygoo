import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';
import 'package:sliding_action_button/sliding_action_button.dart';

class SliderButton extends StatelessWidget {
  final String label;
  final String completedLabel;
  final VoidCallback? onSlideCompleted;
  final VoidCallback? onSlideCanceled;

  const SliderButton({
    super.key,
    required this.label,
    this.completedLabel = 'Processing...',
    this.onSlideCompleted,
    this.onSlideCanceled,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleSlideToActionButton(
              width: MediaQuery.of(context).size.width - 40,
              height: 50,
              parentBoxRadiusValue: 50,
              circleSlidingButtonSize: 50,
              initialSlidingActionLabel: label,
              finalSlidingActionLabel: completedLabel,
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
              onSlideActionCompleted: () => onSlideCompleted?.call(),
              onSlideActionCanceled: () => onSlideCanceled?.call(),
            ),
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
    );
  }
}
