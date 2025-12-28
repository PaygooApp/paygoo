import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

enum AppCheckboxStyle { rectangular, circular }

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.style = AppCheckboxStyle.rectangular,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final AppCheckboxStyle style;

  static const _animationDuration = Duration(milliseconds: 150);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null
          ? () {
              HapticFeedback.lightImpact();
              onChanged!(!value);
            }
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: _animationDuration,
            curve: Curves.fastLinearToSlowEaseIn,
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: value
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              shape: style == AppCheckboxStyle.circular
                  ? BoxShape.circle
                  : BoxShape.rectangle,
              borderRadius: style == AppCheckboxStyle.rectangular
                  ? BorderRadius.circular(
                      TokenPrimitiveMode1.borderRadiusxs.toDouble(),
                    )
                  : null,
              border: Border.all(
                color: value
                    ? Theme.of(context).colorScheme.primary
                    : TokenPrimitiveMode1.gray400,
                width: TokenPrimitiveMode1.borderWidthmd.toDouble(),
              ),
            ),
            child: AnimatedScale(
              scale: value ? 1.0 : 0.0,
              duration: _animationDuration,
              curve: Curves.fastLinearToSlowEaseIn,
              child: Image.asset(
                'assets/images/icons/check.png',
                width: 16,
                height: 16,
              ),
            ),
          ),
          if (label != null) ...[
            SizedBox(width: TokenPrimitiveMode1.scale200.toDouble()),
            Text(label!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
