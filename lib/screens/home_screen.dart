import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paygoo/components/atoms/section_header.dart';
import 'package:paygoo/components/compose/order_items_cards_layout.dart';
import 'package:paygoo/components/compose/order_items_grouped_layout.dart';
import 'package:paygoo/components/modals/custom_tip_modal.dart';
import 'package:paygoo/components/wrappers/bottom_summary_card.dart';
import 'package:paygoo/components/wrappers/order_item_card.dart';
import 'package:paygoo/components/wrappers/overscroll_container.dart';
import 'package:paygoo/components/wrappers/payment_methods_card.dart';
import 'package:paygoo/components/wrappers/sticky_venue_header.dart';
import 'package:paygoo/mocks/order_items_mock.dart';
import 'package:paygoo/mocks/venue_mock.dart';
import 'package:paygoo/providers/order_selections_provider.dart';
import 'package:paygoo/utils/order_calculator.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    this.enableStickyVenueHeader = true,
    this.orderItemLayoutStyle = OrderItemLayoutStyle.grouped,
  });

  /// When true, the VenueTableCard becomes a sticky header with glass effect
  /// when scrolling down. When false, it scrolls normally with the content.
  final bool enableStickyVenueHeader;

  /// Layout style for order items:
  /// - [OrderItemLayoutStyle.cards] - Each item is a separate card with shadow
  /// - [OrderItemLayoutStyle.grouped] - All items grouped in a wave paper container
  final OrderItemLayoutStyle orderItemLayoutStyle;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int? _selectedTipIndex;
  double? _customTipPercentage;

  // Scroll controller for tracking scroll position
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Show the custom tip modal
  Future<void> _showCustomTipModal(OrderSelectionsState selectionsState) async {
    final calculator = _createCalculator(selectionsState);
    final result = await CustomTipModal.show(
      context,
      baseAmount: calculator.itemTotal,
      initialTipPercentage: _customTipPercentage,
    );
    if (result != null) {
      setState(() {
        _customTipPercentage = result;
        _selectedTipIndex = 3; // Select "Custom" option
      });
    }
  }

  /// Creates an OrderCalculator with current selections state
  OrderCalculator _createCalculator(OrderSelectionsState selectionsState) {
    return OrderCalculator(
      items: OrderItemsMock.items,
      selections: selectionsState.selections,
    );
  }

  void _selectAll() {
    ref.read(orderSelectionsProvider.notifier).selectAll(OrderItemsMock.items);
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
    ref
        .read(orderSelectionsProvider.notifier)
        .deselectAll(OrderItemsMock.items);
  }

  /// Builds the order items list based on the selected layout style
  Widget _buildOrderItemsList(
    BuildContext context,
    OrderSelectionsState selectionsState,
  ) {
    if (widget.orderItemLayoutStyle == OrderItemLayoutStyle.grouped) {
      return _buildGroupedLayout(context, selectionsState);
    } else {
      return _buildCardsLayout(context, selectionsState);
    }
  }

  void _handleSelectionChanged(String itemId, bool isSelected) {
    ref
        .read(orderSelectionsProvider.notifier)
        .updateSelection(itemId, isSelected);
  }

  void _handleQuantityChanged(String itemId, int quantity) {
    ref.read(orderSelectionsProvider.notifier).updateQuantity(itemId, quantity);
  }

  Widget _buildGroupedLayout(
    BuildContext context,
    OrderSelectionsState selectionsState,
  ) {
    return OrderItemsGroupedLayout(
      items: OrderItemsMock.items,
      selections: selectionsState.selections,
      onSelectedChanged: _handleSelectionChanged,
      onQuantityChanged: _handleQuantityChanged,
    );
  }

  Widget _buildCardsLayout(
    BuildContext context,
    OrderSelectionsState selectionsState,
  ) {
    return OrderItemsCardsLayout(
      items: OrderItemsMock.items,
      selections: selectionsState.selections,
      onSelectedChanged: _handleSelectionChanged,
      onQuantityChanged: _handleQuantityChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the selections provider for reactive updates
    final selectionsState = ref.watch(orderSelectionsProvider);
    final calculator = _createCalculator(selectionsState);

    return StickyVenueHeader(
      scrollController: _scrollController,
      enableStickyHeader: widget.enableStickyVenueHeader,
      venue: VenueMock.tavernaRacilor,
      // BlurHash generated from background_app.png at https://blurha.sh
      coverImageBlurHash: 'LiMj{sRiM{V?ysf5t7ofpdogRkW=',
      builder: (context, coverSection, stickyOverlay) {
        return Scaffold(
          body: Stack(
            children: [
              // Scrollable content with overscroll messages
              OverscrollContainer(
                scrollController: _scrollController,
                bottomPadding: selectionsState.hasAnySelected ? 250 : 16,
                child: Column(
                  children: [
                    // Cover image with overlapping VenueTableCard
                    coverSection,
                    // Spacing to account for the overlapping card
                    const SizedBox(height: 64), // cardOverlap (40) + 24
                    // Rest of content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(
                            title: "Pay Your Bill",
                            actionText: selectionsState.hasAnySelected
                                ? "Deselect All"
                                : "Select All",
                            onActionTap: selectionsState.hasAnySelected
                                ? _deselectAll
                                : _selectAll,
                          ),
                          SizedBox(height: 16),
                          // Order list - layout depends on style
                          _buildOrderItemsList(context, selectionsState),
                          SizedBox(height: 16),
                          // Payment Methods section
                          SectionHeader(title: "Payment Methods"),
                          SizedBox(height: 16),
                          const PaymentMethodsCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Sticky header with glass effect
              if (stickyOverlay != null) stickyOverlay,
              BottomSummaryCard(
                isVisible: selectionsState.hasAnySelected,
                selectedItemsTotal: calculator.itemTotal,
                selectedTipIndex: _selectedTipIndex,
                customTipPercentage: _customTipPercentage,
                onTipChanged: (index) {
                  setState(() {
                    _selectedTipIndex = index;
                  });
                },
                onCustomTipTapped: () => _showCustomTipModal(selectionsState),
                onSlideCompleted: () {
                  // TODO: Handle payment
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
