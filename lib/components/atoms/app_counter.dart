import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// Configuration class for [AppCounter] styling.
class AppCounterStyle {
  const AppCounterStyle({
    this.activeBackgroundColor = TokenPrimitiveMode1.basewhite,
    this.inactiveBackgroundColor = Colors.transparent,
    this.activeBorderColor = TokenPrimitiveMode1.gray800,
    this.inactiveBorderColor = TokenPrimitiveMode1.gray400,
    this.activeTextColor = TokenPrimitiveMode1.gray800,
    this.inactiveTextColor = TokenPrimitiveMode1.gray400,
    this.activeIconColor = TokenPrimitiveMode1.gray800,
    this.disabledIconColor = TokenPrimitiveMode1.gray400,
    this.height = 32.0,
    this.minWidth = 32.0,
    this.buttonSize = 28.0,
    this.padding = 8.0,
    this.borderRadius = 4.0,
    this.iconSize = 18.0,
    this.animationDuration = const Duration(milliseconds: 250),
  });

  final Color activeBackgroundColor;
  final Color inactiveBackgroundColor;
  final Color activeBorderColor;
  final Color inactiveBorderColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final Color activeIconColor;
  final Color disabledIconColor;

  /// Height of the counter container.
  final double height;

  /// Minimum width when inactive (collapsed).
  final double minWidth;

  /// Size of the increment/decrement buttons.
  final double buttonSize;

  /// Padding around the counter value.
  final double padding;

  /// Border radius of the container.
  final double borderRadius;

  /// Size of the +/- icons.
  final double iconSize;

  /// Duration of the expand/collapse animation.
  final Duration animationDuration;

  /// Default style using design tokens.
  static const defaultStyle = AppCounterStyle();
}

/// A counter component with two states: inactive and active.
///
/// **Inactive state**: Displays [maxValue] (available quantity) in a gray bordered rectangle.
/// **Active state**: Expands to show increment/decrement buttons, allowing selection from 1 to [maxValue].
///
/// Example usage:
/// ```dart
/// AppCounter(
///   value: selectedQuantity,
///   maxValue: availableQuantity, // e.g., 5
///   onChanged: (newValue) => setState(() => selectedQuantity = newValue),
///   isActive: isSelected,
/// )
/// ```
class AppCounter extends StatefulWidget {
  const AppCounter({
    super.key,
    required this.value,
    required this.maxValue,
    required this.onChanged,
    this.isActive = false,
    this.step = 1,
    this.style = AppCounterStyle.defaultStyle,
    this.enableHapticFeedback = true,
  });

  /// The current selected value (used when active).
  final int value;

  /// Maximum allowed value. Also displayed when inactive.
  final int maxValue;

  /// Callback when the value changes. Pass null to disable interaction.
  final ValueChanged<int>? onChanged;

  /// Whether the counter is in active state (expanded with controls).
  final bool isActive;

  /// Increment/decrement step value.
  final int step;

  /// Custom styling configuration.
  final AppCounterStyle style;

  /// Whether to trigger haptic feedback on value change.
  final bool enableHapticFeedback;

  @override
  State<AppCounter> createState() => _AppCounterState();
}

class _AppCounterState extends State<AppCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _buttonOpacity;

  AppCounterStyle get _style => widget.style;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    if (widget.isActive) {
      _controller.value = 1.0;
    }
  }

  void _initAnimations() {
    _controller = AnimationController(
      duration: _style.animationDuration,
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _buttonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void didUpdateWidget(AppCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      widget.isActive ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Minimum value is always 1.
  static const int _minValue = 1;

  bool get _canDecrement =>
      widget.onChanged != null && widget.value > _minValue;

  bool get _canIncrement =>
      widget.onChanged != null && widget.value < widget.maxValue;

  /// Display value: shows maxValue when inactive, value when active.
  int get _displayValue => widget.isActive ? widget.value : widget.maxValue;

  void _decrement() {
    if (!_canDecrement) return;
    if (widget.enableHapticFeedback) HapticFeedback.lightImpact();
    widget.onChanged!(widget.value - widget.step);
  }

  void _increment() {
    if (!_canIncrement) return;
    if (widget.enableHapticFeedback) HapticFeedback.lightImpact();
    widget.onChanged!(widget.value + widget.step);
  }

  double get _expandedWidth =>
      _style.minWidth + (_style.buttonSize + _style.padding) * 2;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        final currentWidth =
            _style.minWidth +
            (_expandAnimation.value * (_expandedWidth - _style.minWidth));

        return Container(
          width: currentWidth,
          height: _style.height,
          decoration: _buildDecoration(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(
                icon: Icons.remove_rounded,
                onTap: _decrement,
                isDisabled: !_canDecrement,
                axisAlignment: -1,
              ),
              _buildValueDisplay(),
              _buildControlButton(
                icon: Icons.add_rounded,
                onTap: _increment,
                isDisabled: !_canIncrement,
                axisAlignment: 1,
              ),
            ],
          ),
        );
      },
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: widget.isActive
          ? _style.activeBackgroundColor
          : _style.inactiveBackgroundColor,
      borderRadius: BorderRadius.circular(_style.borderRadius),
      border: Border.all(
        color: widget.isActive
            ? _style.activeBorderColor
            : _style.inactiveBorderColor,
        width: TokenPrimitiveMode1.borderWidthsm.toDouble(),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDisabled,
    required double axisAlignment,
  }) {
    return FadeTransition(
      opacity: _buttonOpacity,
      child: SizeTransition(
        sizeFactor: _expandAnimation,
        axis: Axis.horizontal,
        axisAlignment: axisAlignment,
        child: _CounterIconButton(
          icon: icon,
          onTap: isDisabled ? null : onTap,
          isDisabled: isDisabled,
          size: _style.buttonSize,
          iconSize: _style.iconSize,
          activeColor: _style.activeIconColor,
          disabledColor: _style.disabledIconColor,
        ),
      ),
    );
  }

  Widget _buildValueDisplay() {
    return Expanded(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(_style.padding),
          child: Text(
            _displayValue.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: TokenPrimitiveMode1.typographyfontFamilybody,
              fontSize: TokenPrimitiveMode1.typographyfontSizebodymd.toDouble(),
              fontWeight: FontWeight.w600,
              color: widget.isActive
                  ? _style.activeTextColor
                  : _style.inactiveTextColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// Internal button widget for increment/decrement controls.
class _CounterIconButton extends StatelessWidget {
  const _CounterIconButton({
    required this.icon,
    required this.onTap,
    required this.isDisabled,
    required this.size,
    required this.iconSize,
    required this.activeColor,
    required this.disabledColor,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool isDisabled;
  final double size;
  final double iconSize;
  final Color activeColor;
  final Color disabledColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Icon(
            icon,
            size: iconSize,
            color: isDisabled ? disabledColor : activeColor,
          ),
        ),
      ),
    );
  }
}
