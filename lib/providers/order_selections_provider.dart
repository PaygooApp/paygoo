import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paygoo/mocks/order_items_mock.dart';
import 'package:paygoo/models/order_item.dart';

/// State class holding all order item selections
class OrderSelectionsState {
  final Map<String, OrderItemSelection> selections;

  const OrderSelectionsState({required this.selections});

  /// Creates initial state with all items unselected
  factory OrderSelectionsState.initial(List<OrderItem> items) {
    return OrderSelectionsState(
      selections: {
        for (final item in items) item.id: const OrderItemSelection(),
      },
    );
  }

  /// Check if any item is selected
  bool get hasAnySelected =>
      selections.values.any((selection) => selection.isSelected);

  /// Get selection for a specific item
  OrderItemSelection? getSelection(String itemId) => selections[itemId];

  /// Create a copy with updated selections
  OrderSelectionsState copyWith({Map<String, OrderItemSelection>? selections}) {
    return OrderSelectionsState(selections: selections ?? this.selections);
  }
}

/// Notifier to manage order item selections
class OrderSelectionsNotifier extends Notifier<OrderSelectionsState> {
  @override
  OrderSelectionsState build() {
    return OrderSelectionsState.initial(OrderItemsMock.items);
  }

  /// Update selection state for a single item
  void updateSelection(String itemId, bool isSelected) {
    final current = state.selections[itemId];
    if (current == null) return;

    final updatedSelections = Map<String, OrderItemSelection>.from(
      state.selections,
    );
    updatedSelections[itemId] = current.copyWith(
      isSelected: isSelected,
      selectedQuantity: isSelected ? current.selectedQuantity : 1,
    );

    state = state.copyWith(selections: updatedSelections);
  }

  /// Update quantity for a single item
  void updateQuantity(String itemId, int quantity) {
    final current = state.selections[itemId];
    if (current == null) return;

    final updatedSelections = Map<String, OrderItemSelection>.from(
      state.selections,
    );
    updatedSelections[itemId] = current.copyWith(selectedQuantity: quantity);

    state = state.copyWith(selections: updatedSelections);
  }

  /// Select all items with their maximum available quantities
  void selectAll(List<OrderItem> items) {
    final updatedSelections = <String, OrderItemSelection>{};
    for (final item in items) {
      updatedSelections[item.id] = OrderItemSelection(
        isSelected: true,
        selectedQuantity: item.availableQuantity,
      );
    }
    state = state.copyWith(selections: updatedSelections);
  }

  /// Deselect all items and reset quantities to 1
  void deselectAll(List<OrderItem> items) {
    final updatedSelections = <String, OrderItemSelection>{};
    for (final item in items) {
      updatedSelections[item.id] = const OrderItemSelection();
    }
    state = state.copyWith(selections: updatedSelections);
  }

  /// Reset state to initial (all items unselected)
  void reset(List<OrderItem> items) {
    state = OrderSelectionsState.initial(items);
  }
}

/// Provider for order selections state
final orderSelectionsProvider =
    NotifierProvider<OrderSelectionsNotifier, OrderSelectionsState>(
      OrderSelectionsNotifier.new,
    );
