import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paygoo/components/atoms/overscroll_message.dart';
import 'package:paygoo/components/wrappers/bottom_summary_card.dart';
import 'package:paygoo/components/wrappers/order_item_card.dart';
import 'package:paygoo/components/wrappers/venu_table_card.dart';
import 'package:paygoo/mocks/order_items_mock.dart';
import 'package:paygoo/models/order_item.dart';
import 'package:paygoo/utils/order_calculator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // Map of item id -> selection state
  late Map<String, OrderItemSelection> _selections;

  // Track overscroll amount for fun messages
  double _overscrollAmount = 0.0;

  // Track if haptic has been triggered for this overscroll session
  bool _hapticTriggered = false;

  // Track overscroll count to change message each time
  int _overscrollCount = 0;

  // Threshold for triggering haptic feedback
  static const double _hapticThreshold = 40.0;

  // Scroll controller for tracking scroll position
  late ScrollController _scrollController;

  // Animation controller for sticky header transition
  late AnimationController _stickyAnimationController;

  // Track scroll offset for sticky header
  double _scrollOffset = 0.0;

  // The position where the card should start becoming sticky
  // This is the bottom of the cover image minus the card overlap
  double get _stickyThreshold => _coverHeight - _cardOverlap;

  // Safe area top padding (status bar height)
  double _topPadding = 0.0;

  @override
  void initState() {
    super.initState();
    // Initialize all items as unselected
    _selections = {
      for (final item in OrderItemsMock.items)
        item.id: const OrderItemSelection(),
    };

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _stickyAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _topPadding = MediaQuery.of(context).padding.top;
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    if (offset != _scrollOffset) {
      setState(() {
        _scrollOffset = offset;
      });

      // Animate the sticky header based on scroll position
      if (offset >= _stickyThreshold && _stickyAnimationController.value < 1) {
        _stickyAnimationController.forward();
      } else if (offset < _stickyThreshold &&
          _stickyAnimationController.value > 0) {
        _stickyAnimationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _stickyAnimationController.dispose();
    super.dispose();
  }

  /// Handle scroll notifications to track overscroll
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final pixels = notification.metrics.pixels;
      if (pixels < 0) {
        final newOverscroll = -pixels;

        // Trigger haptic once when crossing threshold
        if (!_hapticTriggered && newOverscroll >= _hapticThreshold) {
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

  /// Order calculator instance - creates fresh instance on each access
  /// to reflect current state. Will work with backend data in the future.
  OrderCalculator get _calculator => OrderCalculator(
    items: OrderItemsMock.items, // Replace with backend items later
    selections: _selections,
  );

  /// Select all items with their maximum available quantity
  void _selectAll() {
    // Update UI immediately
    setState(() {
      for (final item in OrderItemsMock.items) {
        _selections[item.id] = OrderItemSelection(
          isSelected: true,
          selectedQuantity: item.availableQuantity,
        );
      }
    });

    // Run stacking haptic effect in parallel (non-blocking)
    _playStackingHaptic(OrderItemsMock.items.length);
  }

  /// Plays rapid haptic taps to simulate "stacking" items
  void _playStackingHaptic(int count) async {
    for (int i = 0; i < count; i++) {
      HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 40));
    }
  }

  /// Deselect all items and reset quantities to 1
  void _deselectAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      for (final item in OrderItemsMock.items) {
        _selections[item.id] = const OrderItemSelection();
      }
    });
  }

  // Height of the cover image
  static const double _coverHeight = 200.0;
  // How much VenueTableCard overlaps the cover (50% of card height ~60px)
  static const double _cardOverlap = 60.0;

  // Build the VenueTableCard widget (reused in both positions)
  Widget _buildVenueTableCard() {
    return VenueTableCard(
      venueLogo: "venueLogo",
      venueName: "Taverna Racilor",
      tableNumber: "Table:8",
      totalAmount: "\$55.50",
    );
  }

  // Check if the sticky header should be visible
  bool get _showStickyHeader => _scrollOffset >= _stickyThreshold;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fixed message at top - revealed when content scrolls down
          OverscrollMessage(
            overscrollAmount: _overscrollAmount,
            messageIndex: _overscrollCount,
          ),
          // Scrollable content
          NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  // Cover image with overlapping VenueTableCard
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Cover image
                      Container(
                        height: _coverHeight,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/background_app.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // VenueTableCard positioned to overlap bottom of cover
                      // Hide when sticky header is fully visible
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: -_cardOverlap,
                        child: Opacity(
                          opacity: _showStickyHeader ? 0.0 : 1.0,
                          child: _buildVenueTableCard(),
                        ),
                      ),
                    ],
                  ),
                  // Spacing to account for the overlapping card
                  SizedBox(height: _cardOverlap + 24),
                  // Rest of content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pay Your Bill",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            GestureDetector(
                              onTap: _calculator.hasAnySelected
                                  ? _deselectAll
                                  : _selectAll,
                              child: Text(
                                _calculator.hasAnySelected
                                    ? "Deselect All"
                                    : "Select All",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Order list
                        ...OrderItemsMock.items.map((item) {
                          final selection = _selections[item.id]!;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: OrderItemCard(
                              itemName: item.name,
                              price: item.price,
                              isSelected: selection.isSelected,
                              onSelectedChanged: (value) => setState(() {
                                // Get current state to avoid stale closure
                                final current = _selections[item.id]!;
                                _selections[item.id] = current.copyWith(
                                  isSelected: value,
                                  // Reset to 1 when deselecting
                                  selectedQuantity: value
                                      ? current.selectedQuantity
                                      : 1,
                                );
                              }),
                              availableQuantity: item.availableQuantity,
                              selectedQuantity: selection.selectedQuantity,
                              onQuantityChanged: (value) => setState(() {
                                // Get current state to avoid stale closure
                                final current = _selections[item.id]!;
                                _selections[item.id] = current.copyWith(
                                  selectedQuantity: value,
                                );
                              }),
                              showSelectedBorder: false,
                              enableTapAnimation: true,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Sticky header - appears when scrolling down past the threshold
          if (_showStickyHeader)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _stickyAnimationController,
                builder: (context, child) {
                  final progress = _stickyAnimationController.value;
                  // Scale from 0.85 to 1.0 as it animates in
                  final scale = 0.85 + (0.15 * progress);
                  // Slide down from -20 to 0
                  final slideOffset = -20.0 * (1 - progress);

                  return Transform.translate(
                    offset: Offset(0, slideOffset),
                    child: Transform.scale(
                      scale: scale,
                      alignment: Alignment.topCenter,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(
                    top: _topPadding + 8,
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _buildVenueTableCard(),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomSummaryCard(
        itemCount: _calculator.formattedItemCount,
        totalAmount: _calculator.formattedItemTotal,
        buttonText: "Continue to Payment",
        onButtonPressed: () {
          // TODO: Handle payment
        },
      ),
    );
  }
}
