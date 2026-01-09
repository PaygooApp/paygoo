import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paygoo/components/atoms/section_header.dart';
import 'package:paygoo/components/compose/bill_items_grouped_layout.dart';
import 'package:paygoo/components/modals/custom_tip_modal.dart';
import 'package:paygoo/components/wrappers/bottom_summary_card.dart';
import 'package:paygoo/components/wrappers/order_item_card.dart';
import 'package:paygoo/components/wrappers/overscroll_container.dart';
import 'package:paygoo/components/wrappers/payment_methods_card.dart';
import 'package:paygoo/components/wrappers/session_venue_header.dart';
import 'package:paygoo/models/table_session.dart';
import 'package:paygoo/providers/bill_selections_provider.dart';
import 'package:paygoo/utils/bill_calculator.dart';

/// Screen for displaying and paying a bill from a TableSession.
class BillScreen extends ConsumerStatefulWidget {
  const BillScreen({
    super.key,
    required this.session,
    this.enableStickyVenueHeader = true,
    this.orderItemLayoutStyle = OrderItemLayoutStyle.grouped,
  });

  final TableSession session;
  final bool enableStickyVenueHeader;
  final OrderItemLayoutStyle orderItemLayoutStyle;

  @override
  ConsumerState<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends ConsumerState<BillScreen> {
  int? _selectedTipIndex;
  double? _customTipPercentage;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Initialize selections for this bill
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(billSelectionsProvider.notifier).initializeFromBill(
        widget.session.bill!,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showCustomTipModal(BillSelectionsState selectionsState) async {
    final calculator = _createCalculator(selectionsState);
    final result = await CustomTipModal.show(
      context,
      baseAmount: calculator.selectedTotal,
      initialTipPercentage: _customTipPercentage,
    );
    if (result != null) {
      setState(() {
        _customTipPercentage = result;
        _selectedTipIndex = 3;
      });
    }
  }

  BillCalculator _createCalculator(BillSelectionsState selectionsState) {
    return BillCalculator(
      bill: widget.session.bill!,
      selections: selectionsState.selections,
    );
  }

  void _selectAll() {
    ref.read(billSelectionsProvider.notifier).selectAll(widget.session.bill!);
    _playStackingHaptic(widget.session.bill!.items.length);
  }

  void _playStackingHaptic(int count) async {
    for (int i = 0; i < count; i++) {
      HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 40));
    }
  }

  void _deselectAll() {
    HapticFeedback.mediumImpact();
    ref.read(billSelectionsProvider.notifier).deselectAll(widget.session.bill!);
  }

  void _handleSelectionChanged(String itemId, bool isSelected) {
    ref.read(billSelectionsProvider.notifier).updateSelection(itemId, isSelected);
  }

  void _handleQuantityChanged(String itemId, int quantity) {
    ref.read(billSelectionsProvider.notifier).updateQuantity(itemId, quantity);
  }

  @override
  Widget build(BuildContext context) {
    final selectionsState = ref.watch(billSelectionsProvider);
    final calculator = _createCalculator(selectionsState);
    final bill = widget.session.bill!;

    return SessionVenueHeader(
      scrollController: _scrollController,
      enableStickyHeader: widget.enableStickyVenueHeader,
      session: widget.session,
      builder: (context, coverSection, stickyOverlay) {
        return Scaffold(
          body: Stack(
            children: [
              OverscrollContainer(
                scrollController: _scrollController,
                bottomPadding: selectionsState.hasAnySelected ? 250 : 16,
                child: Column(
                  children: [
                    coverSection,
                    const SizedBox(height: 64),
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
                          const SizedBox(height: 16),
                          BillItemsGroupedLayout(
                            items: bill.unpaidItems,
                            selections: selectionsState.selections,
                            onSelectedChanged: _handleSelectionChanged,
                            onQuantityChanged: _handleQuantityChanged,
                          ),
                          const SizedBox(height: 16),
                          SectionHeader(title: "Payment Methods"),
                          const SizedBox(height: 16),
                          const PaymentMethodsCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (stickyOverlay != null) stickyOverlay,
              BottomSummaryCard(
                isVisible: selectionsState.hasAnySelected,
                selectedItemsTotal: calculator.selectedTotal,
                selectedTipIndex: _selectedTipIndex,
                customTipPercentage: _customTipPercentage,
                onTipChanged: (index) => setState(() => _selectedTipIndex = index),
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

