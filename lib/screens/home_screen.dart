import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paygoo/components/atoms/section_header.dart';
import 'package:paygoo/components/atoms/wave_paper_clipper.dart';
import 'package:paygoo/components/modals/custom_tip_modal.dart';
import 'package:paygoo/components/modals/info_bottom_modal.dart';
import 'package:paygoo/components/wrappers/bottom_summary_card.dart';
import 'package:paygoo/components/wrappers/order_item_card.dart';
import 'package:paygoo/components/wrappers/overscroll_container.dart';
import 'package:paygoo/components/wrappers/payment_methods_card.dart';
import 'package:paygoo/components/wrappers/sticky_venue_header.dart';
import 'package:paygoo/mocks/order_items_mock.dart';
import 'package:paygoo/mocks/payment_result_mock.dart';
import 'package:paygoo/models/order_item.dart';
import 'package:paygoo/screens/payment_result_screen.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';
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
    InfoBottomModal.show(
      context,
      icon: SvgPicture.asset('assets/Icon-Unsuccessful-flutter-shadow.svg'),
      subtitle: Text(
        'Payment Failed',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          color: TokenPrimitiveMode1.accenterror700,
          decoration: TextDecoration.none,
        ),
      ),
      title: 'Unable to Process Payment',
      description:
          'There was an issue finalizing your payment. Please try again later.',
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

  /// Builds the order items list based on the selected layout style
  Widget _buildOrderItemsList(BuildContext context) {
    if (widget.orderItemLayoutStyle == OrderItemLayoutStyle.grouped) {
      return _buildGroupedLayout(context);
    } else {
      return _buildCardsLayout(context);
    }
  }

  /// Builds the grouped layout with wave paper container
  Widget _buildGroupedLayout(BuildContext context) {
    return WavePaperContainer(
      color: Theme.of(context).colorScheme.surface,
      waveHeight: 10,
      waveWidth: 20,
      topRadius: 16,
      //TODO: explore this version
      // borderColor: TokenPrimitiveMode1.gray200,
      // borderWidth: 1,
      boxShadow: [
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 6,
          offset: Offset(0, -2),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Color(0x10000000),
          blurRadius: 8,
          offset: Offset(0, 3),
          spreadRadius: 0,
        ),
      ],
      child: Column(
        children: [
          ...OrderItemsMock.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final selection = _selections[item.id]!;
            final isLast = index == OrderItemsMock.items.length - 1;
            return Column(
              children: [
                OrderItemCard(
                  itemName: item.name,
                  price: item.price,
                  isSelected: selection.isSelected,
                  onSelectedChanged: (value) => setState(() {
                    final current = _selections[item.id]!;
                    _selections[item.id] = current.copyWith(
                      isSelected: value,
                      selectedQuantity: value ? current.selectedQuantity : 1,
                    );
                  }),
                  availableQuantity: item.availableQuantity,
                  selectedQuantity: selection.selectedQuantity,
                  onQuantityChanged: (value) => setState(() {
                    final current = _selections[item.id]!;
                    _selections[item.id] = current.copyWith(
                      selectedQuantity: value,
                    );
                  }),
                  showSelectedBorder: false,
                  enableTapAnimation: true,
                  layoutStyle: OrderItemLayoutStyle.grouped,
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: TokenPrimitiveMode1.gray200,
                    indent: 0,
                    endIndent: 0,
                  ),
                if (isLast) SizedBox(height: 14),
              ],
            );
          }),
        ],
      ),
    );
  }

  /// Builds the cards layout with individual cards
  Widget _buildCardsLayout(BuildContext context) {
    return Column(
      children: [
        ...OrderItemsMock.items.map((item) {
          final selection = _selections[item.id]!;
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: OrderItemCard(
              itemName: item.name,
              price: item.price,
              isSelected: selection.isSelected,
              onSelectedChanged: (value) => setState(() {
                final current = _selections[item.id]!;
                _selections[item.id] = current.copyWith(
                  isSelected: value,
                  selectedQuantity: value ? current.selectedQuantity : 1,
                );
              }),
              availableQuantity: item.availableQuantity,
              selectedQuantity: selection.selectedQuantity,
              onQuantityChanged: (value) => setState(() {
                final current = _selections[item.id]!;
                _selections[item.id] = current.copyWith(
                  selectedQuantity: value,
                );
              }),
              showSelectedBorder: false,
              enableTapAnimation: true,
              layoutStyle: OrderItemLayoutStyle.cards,
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StickyVenueHeader(
      scrollController: _scrollController,
      enableStickyHeader: widget.enableStickyVenueHeader,
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
                          SizedBox(height: 24),
                          // Test buttons
                          ElevatedButton(
                            onPressed: _showInfoModal,
                            child: Text('Test Info Modal'),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PaymentResultScreen(
                                  config: PaymentResultConfig(
                                    iconAsset: 'assets/Icon-Successful.svg',
                                    title: 'Payment Successful',
                                    paymentResult:
                                        PaymentResultMock.successfulPayment,
                                  ),
                                ),
                              ),
                            ),
                            child: const Text('Test Payment Success'),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Sticky header with glass effect
              if (stickyOverlay != null) stickyOverlay,
              // Bottom summary card - slides in from bottom when items selected
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  offset: _calculator.hasAnySelected
                      ? Offset.zero
                      : const Offset(0, 1), // Slide down when hidden
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _calculator.hasAnySelected ? 1.0 : 0.0,
                    child: BottomSummaryCard(
                      selectedItemsTotal: _calculator.itemTotal,
                      isEnabled: _calculator.hasAnySelected,
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
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
