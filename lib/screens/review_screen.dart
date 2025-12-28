import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:paygoo/components/atoms/app_button.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// Map of rating values to their description labels
const Map<int, String> _ratingLabels = {
  0: 'Not rated yet',
  1: 'Poor',
  2: 'Fair',
  3: 'Good',
  4: 'Very Good',
  5: 'Highly Recommended',
};

/// A full-page screen for customer to leave a review with star rating and comment.
class ReviewScreen extends StatefulWidget {
  /// Restaurant name to display
  final String restaurantName;

  /// Table number to display
  final String tableNumber;

  /// Callback when close button is tapped
  final VoidCallback? onClose;

  /// Callback when review is submitted
  final void Function(int rating, String comment)? onSubmit;

  const ReviewScreen({
    super.key,
    required this.restaurantName,
    required this.tableNumber,
    this.onClose,
    this.onSubmit,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _rating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final coverHeight = screenHeight * 0.36;

    return Scaffold(
      backgroundColor: TokenPrimitiveMode1.basewhite,
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Header with cover image
              _buildHeader(context, coverHeight, topPadding),
              // White card container with content
              Expanded(child: _buildContentCard(context)),
            ],
          ),
          // Fixed bottom button with safe area margin
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: TokenPrimitiveMode1.basewhite,
              padding: const EdgeInsets.fromLTRB(15, 24, 15, 40),
              child: _buildSubmitButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    double coverHeight,
    double topPadding,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cover image
        SizedBox(
          height: coverHeight,
          width: double.infinity,
          child: Image.asset(
            'assets/review_image.png',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        // Close button
        Positioned(
          top: topPadding + 8,
          right: 16,
          child: _buildCloseButton(context),
        ),
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose ?? () => Navigator.of(context).pop(),
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

  Widget _buildContentCard(BuildContext context) {
    // Button area height: 24px top padding + 56px button + 24px bottom padding (matching payment_result_screen)
    const double buttonAreaHeight = 24 + 56 + 24;

    return Transform.translate(
      offset: const Offset(0, -24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: TokenPrimitiveMode1.basewhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Venue info row with 8px padding
            Padding(
              padding: const EdgeInsets.all(8),
              child: _buildVenueInfoRow(context),
            ),
            // Scrollable content
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, buttonAreaHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      'How Was Your Experience?',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: TokenPrimitiveMode1.gray900,
                            fontWeight: FontWeight.w700,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Help us to improve your experience at ${widget.restaurantName}.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: TokenPrimitiveMode1.gray600,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Star rating
                    _buildStarRating(context),
                    const SizedBox(height: 24),
                    // Comment section
                    Expanded(child: _buildCommentSection(context)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVenueInfoRow(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: TokenPrimitiveMode1.gray50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: TokenPrimitiveMode1.gray100,
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset('assets/Logo1.png', fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          // Restaurant name
          Expanded(
            child: Text(
              widget.restaurantName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: TokenPrimitiveMode1.gray900,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Table label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: TokenPrimitiveMode1.primary500,
              borderRadius: BorderRadius.circular(
                TokenPrimitiveMode1.borderRadiusround.toDouble(),
              ),
            ),
            child: Text(
              'Table: ${widget.tableNumber}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: TokenPrimitiveMode1.basewhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starNumber = index + 1;
            final isSelected = starNumber <= _rating;
            return _AnimatedStar(
              isSelected: isSelected,
              onTap: () => setState(() => _rating = starNumber),
            );
          }),
        ),
        const SizedBox(height: 24),
        Text(
          _ratingLabels[_rating] ?? 'Not rated yet',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: TokenPrimitiveMode1.gray950,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCommentSection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: TokenPrimitiveMode1.gray50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TokenPrimitiveMode1.gray200, width: 1),
      ),
      child: TextField(
        controller: _commentController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          hintText: 'Tell us about your experience... (optional)',
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: TokenPrimitiveMode1.gray600),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: TokenPrimitiveMode1.gray900),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final isEnabled = _rating > 0;
    return AppButton(
      text: 'Submit Review',
      onPressed: isEnabled
          ? () {
              widget.onSubmit?.call(_rating, _commentController.text);
            }
          : () {},
      fullWidth: true,
    );
  }
}

/// Animated star widget with scale bounce effect on tap
class _AnimatedStar extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _AnimatedStar({required this.isSelected, required this.onTap});

  @override
  State<_AnimatedStar> createState() => _AnimatedStarState();
}

class _AnimatedStarState extends State<_AnimatedStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.15,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 60,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_AnimatedStar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward(from: 0);
    }
  }

  void _handleTap() {
    _controller.forward(from: 0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: SvgPicture.asset(
            widget.isSelected ? 'assets/star_true.svg' : 'assets/star.svg',
            width: 48,
            height: 48,
          ),
        ),
      ),
    );
  }
}
