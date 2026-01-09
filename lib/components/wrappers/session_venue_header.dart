import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:paygoo/components/atoms/blurhash_image.dart';
import 'package:paygoo/components/wrappers/venu_table_card.dart';
import 'package:paygoo/models/currency.dart';
import 'package:paygoo/models/table_session.dart';

/// Builder callback for session venue header
typedef SessionVenueHeaderBuilder = Widget Function(
  BuildContext context,
  Widget coverSection,
  Widget? stickyOverlay,
);

/// Venue header that works with TableSession instead of Venue.
class SessionVenueHeader extends StatefulWidget {
  const SessionVenueHeader({
    super.key,
    required this.scrollController,
    required this.builder,
    required this.session,
    this.enableStickyHeader = true,
    this.coverHeight = 200.0,
    this.cardOverlap = 40.0,
    this.currency = Currency.usd,
  });

  final ScrollController scrollController;
  final SessionVenueHeaderBuilder builder;
  final TableSession session;
  final bool enableStickyHeader;
  final double coverHeight;
  final double cardOverlap;
  final Currency currency;

  @override
  State<SessionVenueHeader> createState() => _SessionVenueHeaderState();
}

class _SessionVenueHeaderState extends State<SessionVenueHeader>
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
      setState(() => _scrollOffset = offset);
      if (offset >= _stickyThreshold && _animationController.value < 1) {
        _animationController.forward();
      } else if (offset < _stickyThreshold && _animationController.value > 0) {
        _animationController.reverse();
      }
    }
  }

  Widget _buildVenueTableCard() {
    final restaurant = widget.session.restaurant!;
    final table = widget.session.table!;
    final bill = widget.session.bill;
    
    return VenueTableCard(
      venueLogo: restaurant.logoUrl,
      venueName: restaurant.name,
      tableNumber: table.displayLabel,
      totalAmount: bill != null 
          ? widget.currency.format(bill.totalAmount)
          : 'No active bill',
    );
  }

  @override
  Widget build(BuildContext context) {
    final coverSection = _buildCoverSection();
    final stickyOverlay = _showStickyHeader ? _buildStickyHeader(context) : null;
    return widget.builder(context, coverSection, stickyOverlay);
  }

  Widget _buildCoverSection() {
    final restaurant = widget.session.restaurant!;
    final coverImage = restaurant.coverImageUrl ?? 
        'assets/images/cover/background_app.png';
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (restaurant.coverImageBlurHash != null)
          BlurHashImage(
            blurHash: restaurant.coverImageBlurHash!,
            imagePath: coverImage,
            height: widget.coverHeight,
            width: double.infinity,
            fit: BoxFit.cover,
            duration: const Duration(milliseconds: 1500),
          )
        else
          Container(
            height: widget.coverHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(coverImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
        Positioned(
          left: 16,
          right: 16,
          bottom: -widget.cardOverlap,
          child: widget.enableStickyHeader
              ? AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) => Opacity(
                    opacity: 1.0 - _animationController.value,
                    child: child,
                  ),
                  child: _buildVenueTableCard(),
                )
              : _buildVenueTableCard(),
        ),
      ],
    );
  }

  Widget _buildStickyHeader(BuildContext context) {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final progress = _animationController.value;
          return Opacity(
            opacity: progress,
            child: Transform.translate(
              offset: Offset(0, -20.0 * (1 - progress)),
              child: Transform.scale(
                scale: 0.85 + (0.15 * progress),
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
                top: _topPadding + 8, left: 16, right: 16, bottom: 12,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.2), width: 1,
                  ),
                ),
              ),
              child: _buildVenueTableCard(),
            ),
          ),
        ),
      ),
    );
  }
}

