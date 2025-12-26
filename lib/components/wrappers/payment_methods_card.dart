import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paygoo/components/atoms/app_radio_button.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// A card displaying payment method options (Apple Pay, Google Pay, Cards)
/// with radio button selection.
class PaymentMethodsCard extends StatefulWidget {
  const PaymentMethodsCard({
    super.key,
    this.initialSelectedIndex = 0,
    this.onPaymentMethodChanged,
  });

  /// The initially selected payment method index
  final int initialSelectedIndex;

  /// Callback when payment method selection changes
  final ValueChanged<int>? onPaymentMethodChanged;

  @override
  State<PaymentMethodsCard> createState() => _PaymentMethodsCardState();
}

class _PaymentMethodsCardState extends State<PaymentMethodsCard> {
  late int _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod = widget.initialSelectedIndex;
  }

  /// Builds a bordered box for payment method icons
  Widget _buildPaymentIconBox({
    required Widget child,
    double? width,
    double? height,
  }) {
    return Container(
      width: width ?? 58,
      height: height ?? 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: TokenPrimitiveMode1.gray300, width: 1),
      ),
      child: Center(child: child),
    );
  }

  /// Builds a payment method row item
  Widget _buildPaymentMethodItem({
    required int index,
    required String title,
    required Widget trailing,
    required bool isLast,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedPaymentMethod = index;
        });
        widget.onPaymentMethodChanged?.call(index);
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: TokenPrimitiveMode1.scale300.toDouble(),
              vertical: 12,
            ),
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              children: [
                AppRadioButton(
                  value: index,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                    widget.onPaymentMethodChanged?.call(value);
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                trailing,
              ],
            ),
          ),
          if (!isLast)
            Divider(
              height: 1,
              thickness: 1,
              color: TokenPrimitiveMode1.gray200,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A000000),
            blurRadius: 6,
            offset: const Offset(0, -2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0x10000000),
            blurRadius: 8,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Apple Pay - iOS only
          if (Platform.isIOS)
            _buildPaymentMethodItem(
              index: 0,
              title: "Apple Pay",
              trailing: _buildPaymentIconBox(
                child: SvgPicture.asset(
                  'assets/apple_pay.svg',
                  height: 13,
                  width: 29,
                ),
              ),
              isLast: false,
            ),
          // Google Pay - Android only
          if (Platform.isAndroid)
            _buildPaymentMethodItem(
              index: 1,
              title: "Google Pay",
              trailing: _buildPaymentIconBox(
                child: SvgPicture.asset(
                  'assets/g_pay.svg',
                  height: 13,
                  width: 29,
                ),
              ),
              isLast: false,
            ),
          // Cards
          _buildPaymentMethodItem(
            index: 2,
            title: "Card",
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPaymentIconBox(
                  child: SvgPicture.asset('assets/visa.svg', height: 13),
                ),
                const SizedBox(width: 8),
                _buildPaymentIconBox(
                  child: SvgPicture.asset('assets/mastercard.svg', height: 13),
                ),
              ],
            ),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

