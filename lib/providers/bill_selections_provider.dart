import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paygoo/models/bill.dart';

/// Selection state for a bill item
class BillItemSelection {
  final bool isSelected;
  final int selectedQuantity;

  const BillItemSelection({this.isSelected = false, this.selectedQuantity = 1});

  BillItemSelection copyWith({bool? isSelected, int? selectedQuantity}) {
    return BillItemSelection(
      isSelected: isSelected ?? this.isSelected,
      selectedQuantity: selectedQuantity ?? this.selectedQuantity,
    );
  }
}

/// State class holding all bill item selections
class BillSelectionsState {
  final Map<String, BillItemSelection> selections;

  const BillSelectionsState({required this.selections});

  factory BillSelectionsState.initial() {
    return const BillSelectionsState(selections: {});
  }

  factory BillSelectionsState.fromBill(Bill bill) {
    return BillSelectionsState(
      selections: {
        for (final item in bill.unpaidItems) item.id: const BillItemSelection(),
      },
    );
  }

  bool get hasAnySelected =>
      selections.values.any((selection) => selection.isSelected);

  BillItemSelection? getSelection(String itemId) => selections[itemId];

  BillSelectionsState copyWith({Map<String, BillItemSelection>? selections}) {
    return BillSelectionsState(selections: selections ?? this.selections);
  }
}

/// Notifier to manage bill item selections
class BillSelectionsNotifier extends Notifier<BillSelectionsState> {
  @override
  BillSelectionsState build() {
    return BillSelectionsState.initial();
  }

  /// Initialize selections from a bill
  void initializeFromBill(Bill bill) {
    state = BillSelectionsState.fromBill(bill);
  }

  /// Update selection state for a single item
  void updateSelection(String itemId, bool isSelected) {
    final current = state.selections[itemId];
    if (current == null) return;

    final updatedSelections = Map<String, BillItemSelection>.from(
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

    final updatedSelections = Map<String, BillItemSelection>.from(
      state.selections,
    );
    updatedSelections[itemId] = current.copyWith(selectedQuantity: quantity);

    state = state.copyWith(selections: updatedSelections);
  }

  /// Select all items with their full quantities
  void selectAll(Bill bill) {
    final updatedSelections = <String, BillItemSelection>{};
    for (final item in bill.unpaidItems) {
      updatedSelections[item.id] = BillItemSelection(
        isSelected: true,
        selectedQuantity: item.quantity,
      );
    }
    state = state.copyWith(selections: updatedSelections);
  }

  /// Deselect all items and reset quantities to 1
  void deselectAll(Bill bill) {
    final updatedSelections = <String, BillItemSelection>{};
    for (final item in bill.unpaidItems) {
      updatedSelections[item.id] = const BillItemSelection();
    }
    state = state.copyWith(selections: updatedSelections);
  }

  /// Handle real-time update when bill changes
  void onBillUpdated(Bill updatedBill) {
    // Keep existing selections for items that still exist
    final newSelections = <String, BillItemSelection>{};
    for (final item in updatedBill.unpaidItems) {
      newSelections[item.id] =
          state.selections[item.id] ?? const BillItemSelection();
    }
    state = state.copyWith(selections: newSelections);
  }
}

/// Provider for bill selections state
final billSelectionsProvider =
    NotifierProvider<BillSelectionsNotifier, BillSelectionsState>(
      BillSelectionsNotifier.new,
    );
