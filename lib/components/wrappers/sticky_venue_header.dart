import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:paygoo/components/wrappers/venu_table_card.dart';
import 'package:paygoo/models/venue.dart';

/// Builder callback that receives the cover section and optional sticky overlay.
typedef StickyVenueHeaderBuilder =
    Widget Function(
      BuildContext context,
      Widget coverSection,
      Widget? stickyOverlay,
    );

class StickyVenueHeader extends StatefulWidget {
  const StickyVenueHeader({
    super.key,
    required this.scrollController,
    required this.builder,
    required this.venue,
    required this.totalAmount,
    this.enableStickyHeader = true,
    this.coverHeight = 200.0,
    this.cardOverlap = 40.0,
    this.coverImage = 'assets/images/cover/background_app.png',
  });

  final ScrollController scrollController;
  final StickyVenueHeaderBuilder builder;
  final Venue venue;
  final String totalAmount;
  final bool enableStickyHeader;
  final double coverHeight;
  final double cardOverlap;
  final String coverImage;

  double get spacingBelowCover => cardOverlap + 24;

  @override
  State<StickyVenueHeader> createState() => _StickyVenueHeaderState();
}

class _StickyVenueHeaderState extends State<StickyVenueHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _scrollOffset = 0.0;
  double _topPadding = 0.0;

  double get _stickyThreshold => widget.coverHeight - widget.cardOverlap;

  bool get _showStickyHeader =>
      widget.enableStickyHeader &&
      (_scrollOffset >= _stickyThreshold || _animationController.value > 0);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animationController.addStatusListener(_onAnimationStatusChange);
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _topPadding = MediaQuery.of(context).padding.top;
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _animationController.removeStatusListener(_onAnimationStatusChange);
    _animationController.dispose();
    super.dispose();
  }

  void _onAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.dismissed ||
        status == AnimationStatus.completed) {
      setState(() {});
    }
  }

  void _onScroll() {
    final offset = widget.scrollController.offset;
    if (offset != _scrollOffset) {
      setState(() {
        _scrollOffset = offset;
      });

      if (offset >= _stickyThreshold && _animationController.value < 1) {
        _animationController.forward();
      } else if (offset < _stickyThreshold && _animationController.value > 0) {
        _animationController.reverse();
      }
    }
  }

  Widget _buildVenueTableCard() {
    return VenueTableCard(
      venueLogo: widget.venue.logoUrl,
      venueName: widget.venue.name,
      tableNumber: widget.venue.tableNumber,
      totalAmount: widget.totalAmount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final coverSection = _buildCoverSection();
    final stickyOverlay = _showStickyHeader
        ? _buildStickyHeader(context)
        : null;
    return widget.builder(context, coverSection, stickyOverlay);
  }

  Widget _buildCoverSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cover image
        Container(
          height: widget.coverHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.coverImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // VenueTableCard positioned to overlap bottom of cover
        Positioned(
          left: 16,
          right: 16,
          bottom: -widget.cardOverlap,
          child: widget.enableStickyHeader
              ? AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 1.0 - _animationController.value,
                      child: child,
                    );
                  },
                  child: _buildVenueTableCard(),
                )
              : _buildVenueTableCard(),
        ),
      ],
    );
  }

  Widget _buildStickyHeader(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final progress = _animationController.value;
          final scale = 0.85 + (0.15 * progress);
          final slideOffset = -20.0 * (1 - progress);
          final opacity = progress;

          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(0, slideOffset),
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.topCenter,
                child: child,
              ),
            ),
          );
        },
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: EdgeInsets.only(
                top: _topPadding + 8,
                left: 16,
                right: 16,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.7),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _buildVenueTableCard(),
            ),
          ),
        ),
      ),
    );
  }
}
