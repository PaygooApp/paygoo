import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paygoo/components/compose/order_item_card.dart';
import 'package:paygoo/components/wrappers/venu_table_card.dart';
import 'package:paygoo/mocks/order_items_mock.dart';
import 'package:paygoo/models/order_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Map of item id -> selection state
  late Map<String, OrderItemSelection> _selections;

  @override
  void initState() {
    super.initState();
    // Initialize all items as unselected
    _selections = {
      for (final item in OrderItemsMock.items)
        item.id: const OrderItemSelection(),
    };
  }

  /// Check if at least one item is selected
  bool get _hasAnySelected =>
      _selections.values.any((selection) => selection.isSelected);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paygoo")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              VenueTableCard(
                venueLogo: "venueLogo",
                venueName: "Taverna Racilor",
                tableNumber: "Table:8",
                totalAmount: "\$55.50",
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pay Your Bill",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  GestureDetector(
                    onTap: _hasAnySelected ? _deselectAll : _selectAll,
                    child: Text(
                      _hasAnySelected ? "Deselect All" : "Select All",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
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
                        selectedQuantity: value ? current.selectedQuantity : 1,
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
      ),
    );
  }
}
