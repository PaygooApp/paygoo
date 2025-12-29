import 'package:flutter/material.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// Mock data for InfoBottomModal configurations
class InfoModalConfig {
  final String iconAsset;
  final String? subtitleText;
  final Color? subtitleColor;
  final String title;
  final String description;

  const InfoModalConfig({
    required this.iconAsset,
    this.subtitleText,
    this.subtitleColor,
    required this.title,
    required this.description,
  });
}

class InfoModalMock {
  InfoModalMock._();

  static const InfoModalConfig paymentFailed = InfoModalConfig(
    iconAsset: 'assets/images/icons/Icon-Unsuccessful-flutter-shadow.svg',
    subtitleText: 'Payment Failed',
    subtitleColor: TokenPrimitiveMode1.accenterror700,
    title: 'Unable to Process Payment',
    description:
        'There was an issue finalizing your payment. Please try again later.',
  );

  static const InfoModalConfig paymentSuccess = InfoModalConfig(
    iconAsset: 'assets/images/icons/Icon-Successful-flutter-shadow.svg',
    subtitleText: 'Payment Successful',
    subtitleColor: TokenPrimitiveMode1.accentsuccess700,
    title: 'Thank You!',
    description: 'Your payment has been processed successfully.',
  );

  static const InfoModalConfig networkError = InfoModalConfig(
    iconAsset: 'assets/images/icons/Icon-Unsuccessful-flutter-shadow.svg',
    subtitleText: 'Connection Error',
    subtitleColor: TokenPrimitiveMode1.accenterror700,
    title: 'No Internet Connection',
    description:
        'Please check your internet connection and try again.',
  );
}

