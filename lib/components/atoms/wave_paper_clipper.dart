import 'package:flutter/material.dart';

/// A custom clipper that creates wavy edges on bottom only
/// with rounded corners on top, to give a paper/receipt-like appearance.
class WavePaperClipper extends CustomClipper<Path> {
  final double waveHeight;
  final double waveWidth;
  final double topRadius;

  WavePaperClipper({
    this.waveHeight = 8,
    this.waveWidth = 16,
    this.topRadius = 16,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final waveCount = (size.width / waveWidth).ceil();

    // Start at top-left, after the rounded corner
    path.moveTo(0, topRadius);

    // Top-left rounded corner
    path.quadraticBezierTo(0, 0, topRadius, 0);

    // Top straight edge
    path.lineTo(size.width - topRadius, 0);

    // Top-right rounded corner
    path.quadraticBezierTo(size.width, 0, size.width, topRadius);

    // Right edge down to bottom wave area
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
    path.lineTo(0, topRadius);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// A widget that wraps content with rounded top corners and wavy bottom edge
class WavePaperContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final double waveHeight;
  final double waveWidth;
  final double topRadius;
  final List<BoxShadow>? boxShadow;
  final Color? borderColor;
  final double borderWidth;

  const WavePaperContainer({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.waveHeight = 6,
    this.waveWidth = 12,
    this.topRadius = 16,
    this.boxShadow,
    this.borderColor,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WavePaperShadowPainter(
        color: color,
        waveHeight: waveHeight,
        waveWidth: waveWidth,
        topRadius: topRadius,
        boxShadow: boxShadow,
        borderColor: borderColor,
        borderWidth: borderWidth,
      ),
      child: ClipPath(
        clipper: WavePaperClipper(
          waveHeight: waveHeight,
          waveWidth: waveWidth,
          topRadius: topRadius,
        ),
        child: Container(
          color: color,
          child: Padding(
            padding: EdgeInsets.only(bottom: waveHeight),
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
  final double topRadius;
  final List<BoxShadow>? boxShadow;
  final Color? borderColor;
  final double borderWidth;

  _WavePaperShadowPainter({
    required this.color,
    required this.waveHeight,
    required this.waveWidth,
    required this.topRadius,
    this.boxShadow,
    this.borderColor,
    this.borderWidth = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final clipper = WavePaperClipper(
      waveHeight: waveHeight,
      waveWidth: waveWidth,
      topRadius: topRadius,
    );
    final path = clipper.getClip(size);

    // Draw shadows
    if (boxShadow != null && boxShadow!.isNotEmpty) {
      for (final shadow in boxShadow!) {
        final shadowPaint = Paint()
          ..color = shadow.color
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            shadow.blurRadius / 2,
          );

        canvas.save();
        canvas.translate(shadow.offset.dx, shadow.offset.dy);
        canvas.drawPath(path, shadowPaint);
        canvas.restore();
      }
    }

    // Draw border
    if (borderColor != null) {
      final borderPaint = Paint()
        ..color = borderColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;

      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
