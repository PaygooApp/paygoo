import 'package:flutter/material.dart';
import 'package:paygoo/components/atoms/app_button.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// Welcome screen shown when a QR code has no assigned order.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final bottomPadding = bottomSafeArea > 0 ? bottomSafeArea : 24.0;

    const logoSize = 100.0;
    const logoOverlap = logoSize / 2;
    const logoLabelOverlap = 12.0; // Half of 24px label height
    const spacingAboveText = 28.0;
    const spacingBelowText = 24.0;

    // Calculate fixed heights for content section
    // Text content approximate height (title + spacing + subtitle)
    const textContentHeight = 100.0; // Approximate height for text content
    // Buttons height (primary button + spacing + secondary button)
    const buttonsHeight = 120.0; // Approximate height for buttons

    // Calculate the total content height below the hero image
    final contentHeight =
        logoOverlap +
        logoLabelOverlap +
        spacingAboveText +
        textContentHeight +
        spacingBelowText +
        buttonsHeight +
        bottomPadding;

    // Dynamically calculate hero height to fill remaining space
    final heroHeight = screenHeight - contentHeight;

    return Scaffold(
      backgroundColor: TokenPrimitiveMode1.basewhite,
      body: Stack(
        children: [
          // Hero image - dynamically calculated height
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: heroHeight,
            child: Image.asset('assets/hero_entry.png', fit: BoxFit.cover),
          ),

          // Restaurant logo - overlapping at bottom of hero image
          Positioned(
            top: heroHeight - logoOverlap,
            left: 0,
            right: 0,
            child: Center(child: _buildLogoWithLabel(context, logoSize)),
          ),

          // Content below the logo
          Positioned(
            top: heroHeight + logoOverlap + logoLabelOverlap,
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildContent(context, spacingAboveText, spacingBelowText),
          ),
        ],
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

  Widget _buildContent(
    BuildContext context,
    double spacingAboveText,
    double spacingBelowText,
  ) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    // Match payment result screen: 24px spacing + safe area
    final bottomPadding = bottomSafeArea > 0 ? bottomSafeArea : 24.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Spacing above text
          SizedBox(height: spacingAboveText),
          // Text content
          Column(
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
          // Spacing below text
          SizedBox(height: spacingBelowText),
          // Spacer to push buttons to the bottom
          const Spacer(),
          // Buttons
          Column(
            children: [
              AppButton(
                text: 'Order a waiter',
                onPressed: () {
                  // TODO: Handle order waiter action
                },
                fullWidth: true,
              ),
              const SizedBox(height: 12),
              SizedBox(
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: TokenPrimitiveMode1.gray900,
                          borderRadius: BorderRadius.circular(
                            TokenPrimitiveMode1.borderRadiusround.toDouble(),
                          ),
                        ),
                        child: Text(
                          'Coming soon',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: TokenPrimitiveMode1.basewhite,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
