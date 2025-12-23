import 'package:flutter/material.dart';

/// A custom clipper that creates wavy edges on top and bottom
/// to give a paper/receipt-like appearance.
class WavePaperClipper extends CustomClipper<Path> {
  final double waveHeight;
  final double waveWidth;

  WavePaperClipper({this.waveHeight = 8, this.waveWidth = 16});

  @override
  Path getClip(Size size) {
    final path = Path();
    final waveCount = (size.width / waveWidth).ceil();

    // Start at top-left
    path.moveTo(0, waveHeight);

    // Top wavy edge - semi-circles (scalloped edge)
    for (int i = 0; i < waveCount; i++) {
      final startX = i * waveWidth;
      final endX = ((i + 1) * waveWidth).clamp(0.0, size.width);
      final midX = (startX + endX) / 2;

      // Draw a smooth arc upward
      path.quadraticBezierTo(midX, 0, endX, waveHeight);
    }

    // Right edge
    path.lineTo(size.width, size.height - waveHeight);

    // Bottom wavy edge - semi-circles (scalloped edge)
    for (int i = waveCount - 1; i >= 0; i--) {
      final endX = i * waveWidth;
      final startX = ((i + 1) * waveWidth).clamp(0.0, size.width);
      final midX = (startX + endX) / 2;

      // Draw a smooth arc downward
      path.quadraticBezierTo(midX, size.height, endX, size.height - waveHeight);
    }

    // Left edge back to start
    path.lineTo(0, waveHeight);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// A widget that wraps content with wavy paper edges
class WavePaperContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final double waveHeight;
  final double waveWidth;
  final List<BoxShadow>? boxShadow;

  const WavePaperContainer({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.waveHeight = 6,
    this.waveWidth = 12,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WavePaperShadowPainter(
        color: color,
        waveHeight: waveHeight,
        waveWidth: waveWidth,
        boxShadow: boxShadow,
      ),
      child: ClipPath(
        clipper: WavePaperClipper(waveHeight: waveHeight, waveWidth: waveWidth),
        child: Container(
          color: color,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: waveHeight),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _WavePaperShadowPainter extends CustomPainter {
  final Color color;
  final double waveHeight;
  final double waveWidth;
  final List<BoxShadow>? boxShadow;

  _WavePaperShadowPainter({
    required this.color,
    required this.waveHeight,
    required this.waveWidth,
    this.boxShadow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (boxShadow == null || boxShadow!.isEmpty) return;

    final clipper = WavePaperClipper(
      waveHeight: waveHeight,
      waveWidth: waveWidth,
    );
    final path = clipper.getClip(size);

    for (final shadow in boxShadow!) {
      final shadowPaint = Paint()
        ..color = shadow.color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurRadius / 2);

      canvas.save();
      canvas.translate(shadow.offset.dx, shadow.offset.dy);
      canvas.drawPath(path, shadowPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
