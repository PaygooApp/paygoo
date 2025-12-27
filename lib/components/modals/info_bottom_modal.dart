import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:paygoo/components/atoms/app_button.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// Layout style for CTA buttons
enum ModalButtonLayout {
  /// Buttons stacked vertically (column)
  column,

  /// Buttons side by side (row)
  row,
}

/// Configuration for a CTA button in the modal
class ModalButtonConfig {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const ModalButtonConfig({
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
  });
}

/// A reusable bottom modal with slide-in animation, blur overlay,
/// icon, title, description, and configurable CTA buttons.
class InfoBottomModal extends StatefulWidget {
  /// Icon widget to display (90x90), can be SVG, Image, or any widget
  final Widget icon;

  /// Small subtitle text (14px) displayed above the title
  final String? subtitle;

  /// Main title text (24px)
  final String title;

  /// Description text (16px)
  final String description;

  /// Primary CTA button (green)
  final ModalButtonConfig primaryButton;

  /// Optional secondary CTA button (gray)
  final ModalButtonConfig? secondaryButton;

  /// Layout style for buttons (row or column)
  final ModalButtonLayout buttonLayout;

  /// Whether the modal can be dismissed by tapping outside
  final bool isDismissible;

  const InfoBottomModal({
    super.key,
    required this.icon,
    this.subtitle,
    required this.title,
    required this.description,
    required this.primaryButton,
    this.secondaryButton,
    this.buttonLayout = ModalButtonLayout.row,
    this.isDismissible = true,
  });

  /// Shows the modal with slide-in animation and blur overlay
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget icon,
    String? subtitle,
    required String title,
    required String description,
    required ModalButtonConfig primaryButton,
    ModalButtonConfig? secondaryButton,
    ModalButtonLayout buttonLayout = ModalButtonLayout.row,
    bool isDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return InfoBottomModal(
          icon: icon,
          subtitle: subtitle,
          title: title,
          description: description,
          primaryButton: primaryButton,
          secondaryButton: secondaryButton,
          buttonLayout: buttonLayout,
          isDismissible: isDismissible,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  @override
  State<InfoBottomModal> createState() => _InfoBottomModalState();
}

class _InfoBottomModalState extends State<InfoBottomModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss([dynamic result]) async {
    await _controller.reverse();
    if (mounted) {
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Blurred overlay background
            GestureDetector(
              onTap: widget.isDismissible ? () => _dismiss() : null,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 8 * _fadeAnimation.value,
                  sigmaY: 8 * _fadeAnimation.value,
                ),
                child: Container(
                  color: Colors.black.withValues(
                    alpha: 0.4 * _fadeAnimation.value,
                  ),
                ),
              ),
            ),
            // Modal content
            child!,
          ],
        );
      },
      child: _buildModalContent(),
    );
  }

  Widget _buildModalContent() {
    return SlideTransition(
      position: _slideAnimation,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: TokenPrimitiveMode1.basewhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: 24,
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon (90x90)
                SizedBox(width: 90, height: 90, child: widget.icon),
                const SizedBox(height: 20),
                // Subtitle (labelMedium - 14px, gray600)
                if (widget.subtitle != null) ...[
                  Text(
                    widget.subtitle!,
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                ],
                // Title (headlineMedium - 24px, bold)
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Description (bodySmall - 16px, gray600)
                Text(
                  widget.description,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // CTA Buttons
                _buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    if (widget.secondaryButton == null) {
      // Single primary button
      return SizedBox(
        width: double.infinity,
        child: _buildButton(widget.primaryButton),
      );
    }

    // Two buttons - layout based on buttonLayout
    if (widget.buttonLayout == ModalButtonLayout.column) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: _buildButton(widget.primaryButton),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _buildButton(widget.secondaryButton!, isSecondary: true),
          ),
        ],
      );
    }

    // Row layout (default)
    return Row(
      children: [
        Expanded(
          child: _buildButton(widget.secondaryButton!, isSecondary: true),
        ),
        const SizedBox(width: 12),
        Expanded(child: _buildButton(widget.primaryButton)),
      ],
    );
  }

  Widget _buildButton(ModalButtonConfig config, {bool isSecondary = false}) {
    return AppButton(
      text: config.text,
      style: isSecondary ? AppButtonStyle.secondary : AppButtonStyle.primary,
      onPressed: () {
        config.onPressed();
        if (widget.isDismissible) {
          _dismiss();
        }
      },
    );
  }
}
