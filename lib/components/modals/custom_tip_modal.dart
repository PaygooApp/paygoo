import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// A fun, interactive custom tip modal with a semi-circular slider and emoji.
class CustomTipModal extends StatefulWidget {
  final double baseAmount;
  final double? initialTipPercentage;
  final ValueChanged<double> onTipSelected;

  const CustomTipModal({
    super.key,
    required this.baseAmount,
    this.initialTipPercentage,
    required this.onTipSelected,
  });

  /// Shows the custom tip modal and returns the selected tip percentage
  static Future<double?> show(
    BuildContext context, {
    required double baseAmount,
    double? initialTipPercentage,
  }) {
    return showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomTipModal(
        baseAmount: baseAmount,
        initialTipPercentage: initialTipPercentage,
        onTipSelected: (tip) => Navigator.of(context).pop(tip),
      ),
    );
  }

  @override
  State<CustomTipModal> createState() => _CustomTipModalState();
}

class _CustomTipModalState extends State<CustomTipModal>
    with SingleTickerProviderStateMixin {
  late double _tipPercentage;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  static const List<_EmojiMilestone> _milestones = [
    _EmojiMilestone(0, '😐', 'No tip'),
    _EmojiMilestone(5, '🙂', 'Nice!'),
    _EmojiMilestone(10, '😊', 'Thanks!'),
    _EmojiMilestone(15, '😄', 'Awesome!'),
    _EmojiMilestone(20, '🤩', 'Amazing!'),
    _EmojiMilestone(25, '🥳', 'Incredible!'),
    _EmojiMilestone(30, '🦸', 'Superhero!'),
  ];

  @override
  void initState() {
    super.initState();
    _tipPercentage = widget.initialTipPercentage ?? 15.0;
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  _EmojiMilestone get _currentMilestone {
    for (int i = _milestones.length - 1; i >= 0; i--) {
      if (_tipPercentage >= _milestones[i].percentage) return _milestones[i];
    }
    return _milestones.first;
  }

  void _onSliderChanged(double value) {
    final oldMilestone = _currentMilestone;
    setState(() => _tipPercentage = value);
    final newMilestone = _currentMilestone;
    if (oldMilestone != newMilestone) {
      HapticFeedback.mediumImpact();
      _bounceController.forward().then((_) => _bounceController.reverse());
    }
  }

  double get _tipAmount => widget.baseAmount * _tipPercentage / 100;

  // Arc slider dimensions - must match _buildArcSlider
  static const double _sliderWidth = 280;
  static const double _sliderHeight = 200;

  /// Calculate tip percentage from a touch position
  double _calculateTipFromPosition(Offset localPosition) {
    // Center of the arc (matches the painter's center calculation)
    final center = Offset(_sliderWidth / 2, _sliderHeight - 20);
    final dx = localPosition.dx - center.dx;
    final dy = center.dy - localPosition.dy;

    // If touch is below the center line, use x position to determine 0% or 100%
    if (dy < 0) {
      // Below center: left side = 0%, right side = 30%
      return dx < 0 ? 0.0 : 30.0;
    }

    // Calculate angle from center using atan2
    var angle = math.atan2(dy, dx);

    // Convert to degrees (will be 0-180 for upper semicircle)
    var degrees = angle * 180 / math.pi;

    // Map: 180° (left) = 0%, 0° (right) = 100%
    var progress = (180 - degrees) / 180;
    return (progress * 30).clamp(0.0, 30.0);
  }

  // Track last haptic position to avoid too frequent haptics
  int _lastHapticTip = 0;

  void _updateSliderFromPosition(Offset localPosition, {bool isStart = false}) {
    final rawTip = _calculateTipFromPosition(localPosition);
    // Round to nearest 1% increment
    final newTip = rawTip.round().clamp(0, 30);

    // Haptic feedback on each 1% change
    if (isStart || newTip != _lastHapticTip) {
      HapticFeedback.selectionClick();
      _lastHapticTip = newTip;
    }

    // Update slider with integer percentage
    _onSliderChanged(newTip.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TokenPrimitiveMode1.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Add a custom tip',
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: TokenPrimitiveMode1.gray900,
                ),
              ),
              const SizedBox(height: 32),
              _buildArcSlider(),
              const SizedBox(height: 24),
              _buildTipDisplay(),
              const SizedBox(height: 24),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Track if we're currently dragging on the slider
  bool _isDraggingSlider = false;

  Widget _buildArcSlider() {
    return Center(
      child: SizedBox(
        width: _sliderWidth,
        height: _sliderHeight,
        child: Listener(
          onPointerDown: (event) {
            _isDraggingSlider = true;
            _updateSliderFromPosition(event.localPosition, isStart: true);
          },
          onPointerMove: (event) {
            if (_isDraggingSlider) {
              _updateSliderFromPosition(event.localPosition);
            }
          },
          onPointerUp: (_) {
            _isDraggingSlider = false;
          },
          onPointerCancel: (_) {
            _isDraggingSlider = false;
          },
          child: GestureDetector(
            // These empty handlers claim the gesture so it doesn't bubble up
            onVerticalDragStart: (_) {},
            onVerticalDragUpdate: (_) {},
            onHorizontalDragStart: (_) {},
            onHorizontalDragUpdate: (_) {},
            behavior: HitTestBehavior.opaque,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(_sliderWidth, _sliderHeight),
                  painter: _ArcSliderPainter(
                    progress: _tipPercentage / 30,
                    trackColor: TokenPrimitiveMode1.gray200,
                    progressColor: TokenPrimitiveMode1.primary500,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: _bounceAnimation,
                        child: Text(
                          _currentMilestone.emoji,
                          style: const TextStyle(fontSize: 64),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currentMilestone.message,
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: TokenPrimitiveMode1.primary500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: TokenPrimitiveMode1.primary50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tip percentage',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: TokenPrimitiveMode1.gray500,
                ),
              ),
              Text(
                '${_tipPercentage.round()}%',
                style: GoogleFonts.dmSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: TokenPrimitiveMode1.primary600,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Tip amount',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: TokenPrimitiveMode1.gray500,
                ),
              ),
              Text(
                '\$${_tipAmount.toStringAsFixed(2)}',
                style: GoogleFonts.dmSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: TokenPrimitiveMode1.primary600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => widget.onTipSelected(_tipPercentage),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'Add \$${_tipAmount.toStringAsFixed(2)} tip',
          style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _EmojiMilestone {
  final int percentage;
  final String emoji;
  final String message;
  const _EmojiMilestone(this.percentage, this.emoji, this.message);
}

/// Custom painter for the semi-circular arc slider
class _ArcSliderPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;

  _ArcSliderPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 20);
    final radius = size.width / 2 - 20;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    // Draw track arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      trackPaint,
    );

    // Draw progress arc (only if there's progress)
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        math.pi,
        math.pi * progress,
        false,
        progressPaint,
      );
    }

    // Always draw thumb (even at 0% so user knows it's interactive)
    final thumbAngle = math.pi + (math.pi * progress);
    final thumbX = center.dx + radius * math.cos(thumbAngle);
    final thumbY = center.dy + radius * math.sin(thumbAngle);

    // Outer circle (colored)
    canvas.drawCircle(
      Offset(thumbX, thumbY),
      16,
      Paint()..color = progressColor,
    );
    // Inner circle (white)
    canvas.drawCircle(Offset(thumbX, thumbY), 8, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _ArcSliderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
