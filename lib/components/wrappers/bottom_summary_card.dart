import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paygoo/components/atoms/option_card_selector.dart';
import 'package:paygoo/components/atoms/slider_button.dart';
import 'package:paygoo/components/compose/label_value_row.dart';
import 'package:paygoo/models/currency.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';
import 'package:paygoo/utils/constants/tip_constants.dart';

/// A fixed bottom card that displays order summary information.
/// Includes built-in slide and fade animations based on visibility.
class BottomSummaryCard extends StatelessWidget {
  final double selectedItemsTotal;
  final String initialSlideText;
  final String completedSlideText;
  final VoidCallback? onSlideCompleted;
  final int? selectedTipIndex;
  final ValueChanged<int?>? onTipChanged;
  final double? customTipPercentage;
  final VoidCallback? onCustomTipTapped;
  final Currency currency;
  final bool isVisible;
  final Duration animationDuration;
  final Curve animationCurve;

  const BottomSummaryCard({
    super.key,
    this.selectedItemsTotal = 0.0,
    this.initialSlideText = "Slide to Pay",
    this.completedSlideText = "Processing...",
    this.onSlideCompleted,
    this.selectedTipIndex,
    this.onTipChanged,
    this.customTipPercentage,
    this.onCustomTipTapped,
    this.currency = Currency.usd,
    this.isVisible = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  double get _tipAmount {
    if (selectedTipIndex == null) return 0.0;

    double rawTip;

    if (selectedTipIndex == TipConstants.customTipIndex) {
      rawTip = selectedItemsTotal * (customTipPercentage ?? 0) / 100;
    } else {
      final percentage = TipConstants.tipPercentages[selectedTipIndex!];
      rawTip = selectedItemsTotal * percentage / 100;
    }
    return (rawTip * 100).round() / 100;
  }

  double get _totalAmount => selectedItemsTotal + _tipAmount;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedSlide(
        duration: animationDuration,
        curve: animationCurve,
        offset: isVisible ? Offset.zero : const Offset(0, 1),
        child: AnimatedOpacity(
          duration: animationDuration,
          opacity: isVisible ? 1.0 : 0.0,
          child: _buildCard(context),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TokenPrimitiveMode1.basewhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
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
              if (selectedItemsTotal > 0) ...[
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
                  options: TipConstants.buildTipOptions(
                    customTipPercentage: customTipPercentage,
                  ),
                  selectedIndex: selectedTipIndex,
                  onChanged: (index) {
                    // If Custom is tapped, only trigger modal (don't select yet)
                    if (index == TipConstants.customTipIndex) {
                      onCustomTipTapped?.call();
                      return; // Don't call onTipChanged - modal will handle it
                    }
                    onTipChanged?.call(index);
                  },
                ),
                const SizedBox(height: 12),
                LabelValueRow(
                  label: "Service Fee",
                  value: currency.format(selectedItemsTotal),
                ),
                const SizedBox(height: 12),
                if (selectedTipIndex != null) ...[
                  LabelValueRow(
                    label: "Tip Amount",
                    value: currency.format(_tipAmount),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
              SliderButton(
                label: 'Swipe to pay ${currency.format(_totalAmount)}',
                onSlideCompleted: onSlideCompleted,
              ),
              // const SizedBox(height: 12),
              // const TermsAndConditions(),
            ],
          ),
        ),
      ),
    );
  }
}
