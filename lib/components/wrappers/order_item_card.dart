import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paygoo/components/atoms/app_checkbox.dart';
import 'package:paygoo/components/atoms/app_counter.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

class OrderItemCard extends StatefulWidget {
  const OrderItemCard({
    super.key,
    required this.itemName,
    required this.price,
    required this.isSelected,
    required this.onSelectedChanged,
    required this.availableQuantity,
    required this.selectedQuantity,
    required this.onQuantityChanged,
    this.checkboxStyle = AppCheckboxStyle.circular,
    this.showSelectedBorder = true,
    this.enableTapAnimation = true,
  });

  final String itemName;
  final String price;
  final bool isSelected;
  final ValueChanged<bool> onSelectedChanged;

  /// Maximum available quantity (displayed when inactive).
  final int availableQuantity;

  /// Current selected quantity (1 to [availableQuantity], displayed when active).
  final int selectedQuantity;

  final ValueChanged<int> onQuantityChanged;
  final AppCheckboxStyle checkboxStyle;
  final bool showSelectedBorder;
  final bool enableTapAnimation;

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.enableTapAnimation) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.enableTapAnimation) {
      _controller.reverse();
    }
    _toggleSelection();
  }

  void _onTapCancel() {
    if (widget.enableTapAnimation) {
      _controller.reverse();
    }
  }

  void _toggleSelection() {
    HapticFeedback.lightImpact();
    final newSelectedState = !widget.isSelected;
    widget.onSelectedChanged(newSelectedState);

    // Reset quantity to 1 when deselecting
    if (!newSelectedState) {
      widget.onQuantityChanged(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) =>
          Transform.scale(scale: _scaleAnimation.value, child: child),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: TokenPrimitiveMode1.scale300.toDouble(),
          vertical: TokenPrimitiveMode1.scale300.toDouble(),
        ),
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          children: [
            // Tappable area: checkbox + item details (content only, no fill)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppCheckbox(
                    value: widget.isSelected,
                    onChanged: null,
                    style: widget.checkboxStyle,
                  ),
                  SizedBox(width: TokenPrimitiveMode1.scale300.toDouble()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.itemName,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: TokenPrimitiveMode1.scale100.toDouble()),
                      Text(
                        widget.price,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TokenPrimitiveMode1.gray500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Spacer pushes counter to the right
            const Spacer(),

            // Counter (right side) - NOT tappable for toggle
            AppCounter(
              value: widget.selectedQuantity,
              maxValue: widget.availableQuantity,
              onChanged: widget.onQuantityChanged,
              isActive: widget.isSelected,
              style: AppCounterStyle(
                height: 34.0,
                minWidth: 34.0,
                buttonSize: 24.0,
                iconSize: 18.0,
                padding: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
