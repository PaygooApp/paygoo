import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

class AppCounter extends StatelessWidget {
  const AppCounter({
    super.key,
    required this.value,
    required this.onChanged,
    this.minValue = 0,
    this.maxValue = 99,
  });

  final int value;
  final ValueChanged<int>? onChanged;
  final int minValue;
  final int maxValue;

  void _decrement() {
    if (onChanged != null && value > minValue) {
      HapticFeedback.lightImpact();
      onChanged!(value - 1);
    }
  }

  void _increment() {
    if (onChanged != null && value < maxValue) {
      HapticFeedback.lightImpact();
      onChanged!(value + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDecrementDisabled = onChanged == null || value <= minValue;
    final isIncrementDisabled = onChanged == null || value >= maxValue;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CounterButton(
          icon: Icons.remove,
          onTap: isDecrementDisabled ? null : _decrement,
          isDisabled: isDecrementDisabled,
        ),
        SizedBox(
          width: 32,
          child: Text(
            value.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _CounterButton(
          icon: Icons.add,
          onTap: isIncrementDisabled ? null : _increment,
          isDisabled: isIncrementDisabled,
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.onTap,
    required this.isDisabled,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isDisabled
              ? TokenPrimitiveMode1.gray100
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(
            TokenPrimitiveMode1.borderRadiussm.toDouble(),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDisabled
              ? TokenPrimitiveMode1.gray400
              : TokenPrimitiveMode1.basewhite,
        ),
      ),
    );
  }
}

