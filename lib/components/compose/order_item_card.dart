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
    required this.quantity,
    required this.onQuantityChanged,
    this.checkboxStyle = AppCheckboxStyle.circular,
    this.showSelectedBorder = true,
    this.enableTapAnimation = true,
  });

  final String itemName;
  final String price;
  final bool isSelected;
  final ValueChanged<bool> onSelectedChanged;
  final int quantity;
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
    widget.onSelectedChanged(!widget.isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(TokenPrimitiveMode1.scale300.toDouble()),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(
              TokenPrimitiveMode1.borderRadiuslg.toDouble(),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 35,
                offset: Offset(0, 6),
                spreadRadius: 0,
              ),
            ],
            border: Border.all(
              color: (widget.isSelected && widget.showSelectedBorder)
                  ? Theme.of(context).colorScheme.primary
                  : TokenPrimitiveMode1.basewhite,
              width: TokenPrimitiveMode1.borderWidthsm.toDouble(),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    AppCheckbox(
                      value: widget.isSelected,
                      onChanged: null, // Disable direct tap, card handles it
                      style: widget.checkboxStyle,
                    ),
                    SizedBox(width: TokenPrimitiveMode1.scale300.toDouble()),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.itemName,
                            style: Theme.of(context).textTheme.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: TokenPrimitiveMode1.scale100.toDouble(),
                          ),
                          Text(
                            widget.price,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: TokenPrimitiveMode1.gray500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Counter (right side)
              AppCounter(
                value: widget.quantity,
                onChanged: widget.onQuantityChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
