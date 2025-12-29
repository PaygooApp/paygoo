import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paygoo/components/atoms/section_header.dart';
import 'package:paygoo/components/compose/order_items_cards_layout.dart';
import 'package:paygoo/components/compose/order_items_grouped_layout.dart';
import 'package:paygoo/components/modals/custom_tip_modal.dart';
import 'package:paygoo/components/modals/info_bottom_modal.dart';
import 'package:paygoo/components/wrappers/bottom_summary_card.dart';
import 'package:paygoo/components/wrappers/loading_overlay.dart';
import 'package:paygoo/components/wrappers/order_item_card.dart';
import 'package:paygoo/components/wrappers/overscroll_container.dart';
import 'package:paygoo/components/wrappers/payment_methods_card.dart';
import 'package:paygoo/components/wrappers/sticky_venue_header.dart';
import 'package:paygoo/mocks/info_modal_mock.dart';
import 'package:paygoo/mocks/order_items_mock.dart';
import 'package:paygoo/mocks/payment_result_mock.dart';
import 'package:paygoo/mocks/venue_mock.dart';
import 'package:paygoo/models/order_item.dart';
import 'package:paygoo/screens/payment_result_screen.dart';
import 'package:paygoo/screens/welcome_screen.dart';
import 'package:paygoo/utils/order_calculator.dart';

class HomeScreen extends StatefulWidget {
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
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Map of item id -> selection state
  late Map<String, OrderItemSelection> _selections;

  int? _selectedTipIndex;
  double? _customTipPercentage;

  // Scroll controller for tracking scroll position
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Initialize all items as unselected
    _selections = {
      for (final item in OrderItemsMock.items)
        item.id: const OrderItemSelection(),
    };

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Show the custom tip modal
  Future<void> _showCustomTipModal() async {
    final result = await CustomTipModal.show(
      context,
      baseAmount: _calculator.itemTotal,
      initialTipPercentage: _customTipPercentage,
    );
    if (result != null) {
      setState(() {
        _customTipPercentage = result;
        _selectedTipIndex = 3; // Select "Custom" option
      });
    }
  }

  /// Show the info bottom modal (for testing)
  void _showInfoModal() {
    const config = InfoModalMock.paymentFailed;
    InfoBottomModal.show(
      context,
      icon: SvgPicture.asset(config.iconAsset),
      subtitle: Text(
        config.subtitleText ?? '',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          color: config.subtitleColor,
          decoration: TextDecoration.none,
        ),
      ),
      title: config.title,
      description: config.description,
      buttonLayout: ModalButtonLayout.column,
      primaryButton: ModalButtonConfig(text: 'Try again', onPressed: () {}),
    );
  }

  /// Order calculator instance - creates fresh instance on each access
  /// to reflect current state. Will work with backend data in the future.
  OrderCalculator get _calculator => OrderCalculator(
    items: OrderItemsMock.items, // Replace with backend items later
    selections: _selections,
  );

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

  /// Builds the order items list based on the selected layout style
  Widget _buildOrderItemsList(BuildContext context) {
    if (widget.orderItemLayoutStyle == OrderItemLayoutStyle.grouped) {
      return _buildGroupedLayout(context);
    } else {
      return _buildCardsLayout(context);
    }
  }

  void _handleSelectionChanged(String itemId, bool isSelected) {
    setState(() {
      final current = _selections[itemId]!;
      _selections[itemId] = current.copyWith(
        isSelected: isSelected,
        selectedQuantity: isSelected ? current.selectedQuantity : 1,
      );
    });
  }

  void _handleQuantityChanged(String itemId, int quantity) {
    setState(() {
      final current = _selections[itemId]!;
      _selections[itemId] = current.copyWith(selectedQuantity: quantity);
    });
  }

  Widget _buildGroupedLayout(BuildContext context) {
    return OrderItemsGroupedLayout(
      items: OrderItemsMock.items,
      selections: _selections,
      onSelectedChanged: _handleSelectionChanged,
      onQuantityChanged: _handleQuantityChanged,
    );
  }

  Widget _buildCardsLayout(BuildContext context) {
    return OrderItemsCardsLayout(
      items: OrderItemsMock.items,
      selections: _selections,
      onSelectedChanged: _handleSelectionChanged,
      onQuantityChanged: _handleQuantityChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                bottomPadding: _calculator.hasAnySelected ? 200 : 16,
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
                            actionText: _calculator.hasAnySelected
                                ? "Deselect All"
                                : "Select All",
                            onActionTap: _calculator.hasAnySelected
                                ? _deselectAll
                                : _selectAll,
                          ),
                          SizedBox(height: 16),
                          // Order list - layout depends on style
                          _buildOrderItemsList(context),
                          SizedBox(height: 16),
                          // Payment Methods section
                          SectionHeader(title: "Payment Methods"),
                          SizedBox(height: 16),
                          const PaymentMethodsCard(),
                          // SizedBox(height: 24),
                          // // Test buttons
                          // ElevatedButton(
                          //   onPressed: _showInfoModal,
                          //   child: Text('Test Info Modal'),
                          // ),
                          // const SizedBox(height: 12),
                          // ElevatedButton(
                          //   onPressed: () => Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //       builder: (_) => PaymentResultScreen(
                          //         config: PaymentResultConfig(
                          //           iconAsset:
                          //               'assets/images/icons/Icon-Successful.svg',
                          //           title: 'Payment Successful',
                          //           paymentResult:
                          //               PaymentResultMock.successfulPayment,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          //   child: const Text('Test Payment Success'),
                          // ),
                          // const SizedBox(height: 12),
                          // ElevatedButton(
                          //   onPressed: () async {
                          //     LoadingOverlay.show(context);
                          //     // Simulate loading for 3 seconds
                          //     await Future.delayed(const Duration(seconds: 3));
                          //     if (context.mounted) {
                          //       LoadingOverlay.hide(context);
                          //     }
                          //   },
                          //   child: const Text('Test Loading Overlay'),
                          // ),
                          // const SizedBox(height: 12),
                          // ElevatedButton(
                          //   onPressed: () => Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //       builder: (_) => const WelcomeScreen(),
                          //     ),
                          //   ),
                          //   child: const Text('Test Welcome Screen'),
                          // ),
                          // SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Sticky header with glass effect
              if (stickyOverlay != null) stickyOverlay,
              BottomSummaryCard(
                isVisible: _calculator.hasAnySelected,
                selectedItemsTotal: _calculator.itemTotal,
                selectedTipIndex: _selectedTipIndex,
                customTipPercentage: _customTipPercentage,
                onTipChanged: (index) {
                  setState(() {
                    _selectedTipIndex = index;
                  });
                },
                onCustomTipTapped: () => _showCustomTipModal(),
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
