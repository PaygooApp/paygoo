import 'package:flutter/material.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// A widget that displays fun messages when overscrolling at the top.
/// Positioned fixed at the top - content scrolls down to reveal it.
class OverscrollMessage extends StatelessWidget {
  /// The current overscroll amount (negative scroll offset)
  final double overscrollAmount;

  /// Index to select which message to display (changes each overscroll)
  final int messageIndex;

  const OverscrollMessage({
    super.key,
    required this.overscrollAmount,
    this.messageIndex = 0,
  });

  static const List<String> _messages = [
    "Nothing to see here! 👀",
    "Don't forget to enjoy your meal! 🍽️",
    "You've reached the top! 🎉",
    "Great things are coming... ✨",
    "Take a deep breath 🧘",
    "You're doing great! 💪",
    "Hungry? We've got you covered! 🍕",
    "The best is yet to come! 🌟",
    "Relax, we'll handle the bill 😌",
    "Life is good! ☀️",
  ];

  String get _currentMessage => _messages[messageIndex % _messages.length];

  @override
  Widget build(BuildContext context) {
    // Calculate opacity - fade in as user pulls down more
    final opacity = (overscrollAmount / 60).clamp(0.0, 1.0);

    return Positioned(
      top: 60, // Fixed position from top
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Opacity(
          opacity: opacity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _currentMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TokenPrimitiveMode1.gray600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
