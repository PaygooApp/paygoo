import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// A container that handles overscroll with fun messages at the top.
/// Wraps scrollable content and manages all overscroll state internally.
class OverscrollContainer extends StatefulWidget {
  const OverscrollContainer({
    super.key,
    required this.child,
    this.scrollController,
    this.bottomPadding = 16,
    this.hapticThreshold = 40.0,
  });

  /// The scrollable content to wrap
  final Widget child;

  /// Optional scroll controller (one will be created if not provided)
  final ScrollController? scrollController;

  /// Bottom padding for the scroll view
  final double bottomPadding;

  /// Threshold for triggering haptic feedback on overscroll
  final double hapticThreshold;

  @override
  State<OverscrollContainer> createState() => _OverscrollContainerState();
}

class _OverscrollContainerState extends State<OverscrollContainer> {
  double _overscrollAmount = 0.0;
  bool _hapticTriggered = false;
  int _overscrollCount = 0;

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

  String get _currentMessage => _messages[_overscrollCount % _messages.length];

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final pixels = notification.metrics.pixels;
      if (pixels < 0) {
        final newOverscroll = -pixels;

        // Trigger haptic once when crossing threshold
        if (!_hapticTriggered && newOverscroll >= widget.hapticThreshold) {
          HapticFeedback.lightImpact();
          _hapticTriggered = true;
        }

        // Only setState if value changed significantly (performance optimization)
        if ((newOverscroll - _overscrollAmount).abs() > 1) {
          setState(() {
            _overscrollAmount = newOverscroll;
          });
        }
      } else if (_overscrollAmount != 0) {
        // Reset when scroll returns to normal and increment message counter
        _hapticTriggered = false;
        setState(() {
          _overscrollAmount = 0;
          _overscrollCount++;
        });
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate opacity - fade in as user pulls down more
    final opacity = (_overscrollAmount / 60).clamp(0.0, 1.0);

    return Stack(
      children: [
        // Fixed message at top - revealed when content scrolls down
        Positioned(
          top: 60,
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
        ),
        // Scrollable content with notification listener
        NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: SingleChildScrollView(
            controller: widget.scrollController,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: widget.bottomPadding),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

