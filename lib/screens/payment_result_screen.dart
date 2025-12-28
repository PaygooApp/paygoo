import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paygoo/components/atoms/app_button.dart';
import 'package:paygoo/models/payment_result.dart';
import 'package:paygoo/screens/review_screen.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// Configuration for the payment result screen
class PaymentResultConfig {
  final String iconAsset;
  final bool isIconSvg;
  final String title;
  final Widget? subtitle;

  // Payment result data (from API)
  final PaymentResult paymentResult;

  const PaymentResultConfig({
    required this.iconAsset,
    this.isIconSvg = true,
    required this.title,
    required this.paymentResult,
    this.subtitle,
  });

  // Convenience getters to access payment result data
  String get currencySymbol => paymentResult.currencySymbol;
  double get amount => paymentResult.total;
  String get orderId => paymentResult.orderId;
  String get paymentTime => paymentResult.paymentTime;
  String get paymentMethod => paymentResult.paymentMethod;
  double get subtotal => paymentResult.subtotal;
  double get tips => paymentResult.tips;
  double get total => paymentResult.total;
}

/// A full-page screen displaying payment result (success/failure)
class PaymentResultScreen extends StatelessWidget {
  /// Configuration for the screen content
  final PaymentResultConfig config;

  /// Header cover image asset path
  final String headerImageAsset;

  /// Callback when close button is tapped
  final VoidCallback? onClose;

  /// Optional additional content below the amount
  final Widget? additionalContent;

  /// Size of the status icon
  final double iconSize;

  /// How much the icon overlaps the header image
  final double iconOverlap;

  const PaymentResultScreen({
    super.key,
    required this.config,
    this.headerImageAsset = 'assets/images/cover/header_payment.png',
    this.onClose,
    this.additionalContent,
    this.iconSize = 90,
    this.iconOverlap = 45,
  });

  // Payment details are always shown when we have a paymentResult
  bool get _hasPaymentDetails => true;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: TokenPrimitiveMode1.basewhite,
      body: Column(
        children: [
          // Header with cover image and overlapping icon
          _buildHeader(context, topPadding),
          // Fixed content (icon space, title, amount)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                // Space for overlapping icon + 16px gap
                SizedBox(height: iconOverlap + 6),
                // Title
                Text(
                  config.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TokenPrimitiveMode1.accentsuccess600,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Subtitle (optional)
                if (config.subtitle != null) ...[
                  const SizedBox(height: 12),
                  config.subtitle!,
                ],
                const SizedBox(height: 4),
                // Amount
                Text(
                  '${config.currencySymbol}${config.amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Scrollable content (Payment Details, buttons, etc.)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  // Payment Details section
                  if (_hasPaymentDetails) ...[
                    const SizedBox(height: 24),
                    _buildPaymentDetailsSection(context),
                  ],
                  // Action buttons
                  const SizedBox(height: 24),
                  _buildActionButtons(context),
                  // Additional content
                  if (additionalContent != null) ...[
                    const SizedBox(height: 24),
                    additionalContent!,
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double topPadding) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cover image with wave bottom edge
        ClipPath(
          clipper: _BottomWaveClipper(),
          child: SizedBox(
            height: 250,
            width: double.infinity,
            child: Image.asset(
              headerImageAsset,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        // Close button
        Positioned(
          top: topPadding + 8,
          right: 16,
          child: _buildCloseButton(context),
        ),
        // Overlapping icon
        Positioned(
          left: 0,
          right: 0,
          bottom: -iconOverlap,
          child: Center(child: _buildIcon()),
        ),
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: onClose ?? () => Navigator.of(context).pop(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: TokenPrimitiveMode1.basewhite.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.close,
          size: 24,
          color: TokenPrimitiveMode1.gray700,
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: config.isIconSvg
          ? SvgPicture.asset(config.iconAsset)
          : Image.asset(config.iconAsset),
    );
  }

  Widget _buildPaymentDetailsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title with download icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment Details',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.48, // -3% of 16px
                color: TokenPrimitiveMode1.gray900,
              ),
            ),
            // Download receipt icon button
            GestureDetector(
              onTap: () {
                // TODO: Handle download receipt
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: TokenPrimitiveMode1.gray50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.download_rounded,
                  size: 20,
                  color: TokenPrimitiveMode1.gray700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Card with details
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TokenPrimitiveMode1.basewhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDetailRow(
                context,
                'Order ID',
                config.orderId,
                copyable: true,
              ),
              _buildDetailRow(context, 'Payment Time', config.paymentTime),
              _buildDetailRow(context, 'Payment Method', config.paymentMethod),
              // Dotted separator between payment method and subtotal
              const SizedBox(height: 8),
              _buildDottedSeparator(),
              _buildDetailRow(
                context,
                'Sub Total',
                '${config.currencySymbol}${config.subtotal.toStringAsFixed(2)}',
                topPadding: 16,
              ),
              _buildDetailRow(
                context,
                'Tips',
                '${config.currencySymbol}${config.tips.toStringAsFixed(2)}',
              ),
              // Dotted separator between tips and total
              const SizedBox(height: 8),
              _buildDottedSeparator(),
              _buildDetailRow(
                context,
                'Total',
                '${config.currencySymbol}${config.total.toStringAsFixed(2)}',
                isEmphasized: true,
                topPadding: 8,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return AppButton(
      text: 'Leave your review',
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ReviewScreen(
              restaurantName: 'Raos Catering',
              tableNumber: '8',
            ),
          ),
        );
      },
      fullWidth: true,
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isEmphasized = false,
    double? topPadding,
    bool copyable = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 12, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isEmphasized ? FontWeight.w700 : FontWeight.w400,
              color: isEmphasized
                  ? TokenPrimitiveMode1.gray900
                  : TokenPrimitiveMode1.gray700,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isEmphasized ? FontWeight.w700 : FontWeight.w500,
                  color: isEmphasized
                      ? TokenPrimitiveMode1.gray900
                      : TokenPrimitiveMode1.gray700,
                ),
              ),
              if (copyable) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.copy_rounded,
                    size: 16,
                    color: TokenPrimitiveMode1.gray500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDottedSeparator() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 4.0;
        const dashSpace = 6.0;
        final dashCount = (constraints.maxWidth / (dashWidth + dashSpace))
            .floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: TokenPrimitiveMode1.gray100),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Custom clipper that creates a wave pattern on the bottom edge only
class _BottomWaveClipper extends CustomClipper<Path> {
  final double waveHeight;
  final double waveWidth;

  _BottomWaveClipper({this.waveHeight = 8, this.waveWidth = 16});

  @override
  Path getClip(Size size) {
    final path = Path();
    final waveCount = (size.width / waveWidth).ceil();

    // Start at top-left
    path.moveTo(0, 0);

    // Top edge
    path.lineTo(size.width, 0);

    // Right edge down to wave area
    path.lineTo(size.width, size.height - waveHeight);

    // Bottom wavy edge - scalloped pattern (right to left)
    for (int i = waveCount - 1; i >= 0; i--) {
      final endX = i * waveWidth;
      final startX = ((i + 1) * waveWidth).clamp(0.0, size.width);
      final midX = (startX + endX) / 2;

      // Draw arc downward
      path.quadraticBezierTo(midX, size.height, endX, size.height - waveHeight);
    }

    // Left edge back to top
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
