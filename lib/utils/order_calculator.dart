import 'package:paygoo/models/order_item.dart';

/// Utility class for calculating order totals.
/// Designed to work with any list of items (mock or backend).
class OrderCalculator {
  final List<OrderItem> items;
  final Map<String, OrderItemSelection> selections;

  const OrderCalculator({
    required this.items,
    required this.selections,
  });

  /// Get list of selected items with their selections
  List<({OrderItem item, OrderItemSelection selection})> get selectedItems {
    return items
        .where((item) => selections[item.id]?.isSelected ?? false)
        .map((item) => (item: item, selection: selections[item.id]!))
        .toList();
  }

  /// Total count of selected items (sum of quantities)
  int get selectedCount {
    int count = 0;
    for (final item in items) {
      final selection = selections[item.id];
      if (selection != null && selection.isSelected) {
        count += selection.selectedQuantity;
      }
    }
    return count;
  }

  /// Number of unique items selected (not quantities)
  int get selectedUniqueCount {
    return items.where((item) => selections[item.id]?.isSelected ?? false).length;
  }

  /// Total price of selected items
  double get itemTotal {
    double total = 0;
    for (final item in items) {
      final selection = selections[item.id];
      if (selection != null && selection.isSelected) {
        total += item.priceValue * selection.selectedQuantity;
      }
    }
    return total;
  }

  /// Check if any item is selected
  bool get hasAnySelected {
    return items.any((item) => selections[item.id]?.isSelected ?? false);
  }

  /// Format price with currency
  String formatPrice(double value, {String currency = '\$'}) {
    return '$currency${value.toStringAsFixed(2)}';
  }

  /// Get formatted item total
  String get formattedItemTotal => formatPrice(itemTotal);

  /// Get formatted item count string
  String get formattedItemCount {
    final count = selectedCount;
    return '$count ${count == 1 ? 'item' : 'items'}';
  }
}

