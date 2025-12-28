import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// A full-screen loading overlay with blur effect and wave dots animation.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    this.blurAmount = 5.0,
    this.backgroundColor = const Color(0x40000000),
    this.dotSize = 50.0,
  });

  final double blurAmount;
  final Color backgroundColor;
  final double dotSize;

  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      barrierLabel: 'Loading',
      transitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const LoadingOverlay();
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Blur effect
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: blurAmount,
                  sigmaY: blurAmount,
                ),
                child: Container(color: backgroundColor),
              ),
            ),
            Center(
              child: LoadingAnimationWidget.waveDots(
                color: TokenPrimitiveMode1.primary500,
                size: dotSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
