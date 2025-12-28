import 'package:flutter/material.dart';
import 'package:paygoo/components/atoms/app_button.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// Welcome screen shown when a QR code has no assigned order.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final bottomPadding = bottomSafeArea > 0 ? bottomSafeArea : 24.0;

    const logoSize = 100.0;
    const logoOverlap = logoSize / 2;
    const logoLabelOverlap = 12.0; // Half of 24px label height
    const spacingAboveText = 28.0;
    const spacingBelowText = 24.0;

    return Scaffold(
      backgroundColor: TokenPrimitiveMode1.basewhite,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final screenWidth = constraints.maxWidth;

          // Build content to measure it
          final contentWidget = _buildContentColumn(
            context,
            logoSize,
            logoOverlap,
            logoLabelOverlap,
            spacingAboveText,
            spacingBelowText,
            bottomPadding,
          );

          return _HeroWithContent(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            logoOverlap: logoOverlap,
            contentWidget: contentWidget,
          );
        },
      ),
    );
  }

  Widget _buildContentColumn(
    BuildContext context,
    double logoSize,
    double logoOverlap,
    double logoLabelOverlap,
    double spacingAboveText,
    double spacingBelowText,
    double bottomPadding,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo with label
        _buildLogoWithLabel(context, logoSize),
        // Spacing above text
        SizedBox(height: spacingAboveText),
        // Text content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Text(
                'Nothing To Pay Yet!',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: TokenPrimitiveMode1.gray950,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: TokenPrimitiveMode1.gray600,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Please order the food you would like to have by ',
                    ),
                    TextSpan(
                      text: 'calling a waiter',
                      style: TextStyle(
                        color: TokenPrimitiveMode1.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        // Spacing below text (exactly 24px)
        SizedBox(height: spacingBelowText),
        // Buttons
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding),
          child: Column(
            children: [
              AppButton(
                text: 'Order a waiter',
                onPressed: () {
                  // TODO: Handle order waiter action
                },
                fullWidth: true,
              ),
              const SizedBox(height: 12),
              _buildSecondaryButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Handle see menu action
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: TokenPrimitiveMode1.gray100,
          foregroundColor: TokenPrimitiveMode1.gray900,
          elevation: 0,
          shadowColor: Colors.transparent,
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'See menu',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
                color: TokenPrimitiveMode1.gray900,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: TokenPrimitiveMode1.gray900,
                borderRadius: BorderRadius.circular(
                  TokenPrimitiveMode1.borderRadiusround.toDouble(),
                ),
              ),
              child: Text(
                'Coming soon',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: TokenPrimitiveMode1.basewhite,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoWithLabel(BuildContext context, double size) {
    const labelHeight = 24.0;
    const labelOverlap = labelHeight / 2;

    return SizedBox(
      width: size,
      height: size + labelOverlap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Logo circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: TokenPrimitiveMode1.basewhite,
              border: Border.all(
                color: TokenPrimitiveMode1.basewhite,
                width: 3,
              ),
            ),
            child: ClipOval(
              child: Image.asset('assets/Logo1.png', fit: BoxFit.cover),
            ),
          ),
          // Table label - overlapping 50% at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: TokenPrimitiveMode1.primary500,
                  borderRadius: BorderRadius.circular(
                    TokenPrimitiveMode1.borderRadiusround.toDouble(),
                  ),
                ),
                child: Text(
                  'Table: 8',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: TokenPrimitiveMode1.typographyfontSizebodymd
                        .toDouble(),
                    color: TokenPrimitiveMode1.basewhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget that measures content and renders hero image with dynamic height
class _HeroWithContent extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final double logoOverlap;
  final Widget contentWidget;

  const _HeroWithContent({
    required this.screenHeight,
    required this.screenWidth,
    required this.logoOverlap,
    required this.contentWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Content positioned at bottom - this will determine hero height
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _MeasuredContent(
            logoOverlap: logoOverlap,
            screenHeight: screenHeight,
            contentWidget: contentWidget,
          ),
        ),
      ],
    );
  }
}

/// Widget that measures its content and renders the hero image behind it
class _MeasuredContent extends StatefulWidget {
  final double logoOverlap;
  final double screenHeight;
  final Widget contentWidget;

  const _MeasuredContent({
    required this.logoOverlap,
    required this.screenHeight,
    required this.contentWidget,
  });

  @override
  State<_MeasuredContent> createState() => _MeasuredContentState();
}

class _MeasuredContentState extends State<_MeasuredContent> {
  double? _contentHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Hero image positioned above the content
        if (_contentHeight != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: _contentHeight! - widget.logoOverlap,
            child: SizedBox(
              height:
                  widget.screenHeight - _contentHeight! + widget.logoOverlap,
              child: Image.asset('assets/hero_entry.png', fit: BoxFit.cover),
            ),
          ),
        // Measure and display content
        _MeasureSize(
          onChange: (size) {
            if (_contentHeight != size.height) {
              setState(() {
                _contentHeight = size.height;
              });
            }
          },
          child: widget.contentWidget,
        ),
      ],
    );
  }
}

/// Widget that measures its child and reports the size
class _MeasureSize extends StatefulWidget {
  final Widget child;
  final void Function(Size size) onChange;

  const _MeasureSize({required this.child, required this.onChange});

  @override
  State<_MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<_MeasureSize> {
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      widget.onChange(renderBox.size);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(key: _key, child: widget.child);
  }
}
