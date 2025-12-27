import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:paygoo/components/atoms/app_button.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// Layout style for CTA buttons
enum ModalButtonLayout { column, row }

/// Configuration for a CTA button in the modal
class ModalButtonConfig {
  final String text;
  final VoidCallback onPressed;

  const ModalButtonConfig({required this.text, required this.onPressed});
}

/// A reusable bottom modal with slide-in animation, blur overlay,
/// icon, title, description, and configurable CTA buttons.
class InfoBottomModal extends StatefulWidget {
  final Widget icon;
  final Widget? subtitle;
  final String title;
  final String description;
  final ModalButtonConfig primaryButton;
  final ModalButtonConfig? secondaryButton;
  final ModalButtonLayout buttonLayout;
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
    Widget? subtitle,
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
      pageBuilder: (context, animation, secondaryAnimation) => InfoBottomModal(
        icon: icon,
        subtitle: subtitle,
        title: title,
        description: description,
        primaryButton: primaryButton,
        secondaryButton: secondaryButton,
        buttonLayout: buttonLayout,
        isDismissible: isDismissible,
      ),
    );
  }

  @override
  State<InfoBottomModal> createState() => _InfoBottomModalState();
}

class _InfoBottomModalState extends State<InfoBottomModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

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
      begin: 0,
      end: 1,
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
    if (mounted) Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Stack(
        children: [
          // Blurred overlay background
          GestureDetector(
            onTap: widget.isDismissible ? _dismiss : null,
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
      ),
      child: _buildModalContent(context),
    );
  }

  Widget _buildModalContent(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return SlideTransition(
      position: _slideAnimation,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: TokenPrimitiveMode1.basewhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(24, 24, 24, bottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 90, height: 90, child: widget.icon),
              const SizedBox(height: 20),
              if (widget.subtitle != null) ...[
                widget.subtitle!,
                const SizedBox(height: 12),
              ],
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: TokenPrimitiveMode1.gray600,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    final primary = _buildButton(widget.primaryButton, isSecondary: false);
    final secondary = widget.secondaryButton;

    if (secondary == null) {
      return SizedBox(width: double.infinity, child: primary);
    }

    final secondaryBtn = _buildButton(secondary, isSecondary: true);

    return widget.buttonLayout == ModalButtonLayout.column
        ? Column(
            children: [
              SizedBox(width: double.infinity, child: primary),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: secondaryBtn),
            ],
          )
        : Row(
            children: [
              Expanded(child: secondaryBtn),
              const SizedBox(width: 12),
              Expanded(child: primary),
            ],
          );
  }

  Widget _buildButton(ModalButtonConfig config, {required bool isSecondary}) {
    return AppButton(
      text: config.text,
      style: isSecondary ? AppButtonStyle.secondary : AppButtonStyle.primary,
      onPressed: () {
        config.onPressed();
        if (widget.isDismissible) _dismiss();
      },
    );
  }
}
