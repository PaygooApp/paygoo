/// Model representing an order item.
class OrderItem {
  final String id;
  final String name;
  final String price;
  final int availableQuantity;

  const OrderItem({
    required this.id,
    required this.name,
    required this.price,
    required this.availableQuantity,
  });
}

/// Represents the selection state for an order item.
class OrderItemSelection {
  final bool isSelected;
  final int selectedQuantity;

  const OrderItemSelection({
    this.isSelected = false,
    this.selectedQuantity = 1,
  });

  OrderItemSelection copyWith({
    bool? isSelected,
    int? selectedQuantity,
  }) {
    return OrderItemSelection(
      isSelected: isSelected ?? this.isSelected,
      selectedQuantity: selectedQuantity ?? this.selectedQuantity,
    );
  }
}

