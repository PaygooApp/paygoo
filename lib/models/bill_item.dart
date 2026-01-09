/// Model representing an item on a bill.
/// Tracks payment status for split-bill functionality.
class BillItem {
  final String id;
  final String billId;
  final String name;
  final double unitPrice;
  final int quantity;
  final bool isPaid;
  final String? paidByUserId; // For tracking who paid in split scenarios
  final DateTime? paidAt;

  const BillItem({
    required this.id,
    required this.billId,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    this.isPaid = false,
    this.paidByUserId,
    this.paidAt,
  });

  /// Total price for this item (unit price × quantity)
  double get totalPrice => unitPrice * quantity;

  /// Formatted price string
  String get formattedPrice => '\$${totalPrice.toStringAsFixed(2)}';

  /// Formatted unit price string
  String get formattedUnitPrice => '\$${unitPrice.toStringAsFixed(2)}';

  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      id: json['id'] as String,
      billId: json['bill_id'] as String,
      name: json['name'] as String,
      unitPrice: (json['unit_price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      isPaid: json['is_paid'] as bool? ?? false,
      paidByUserId: json['paid_by_user_id'] as String?,
      paidAt: json['paid_at'] != null
          ? DateTime.parse(json['paid_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bill_id': billId,
      'name': name,
      'unit_price': unitPrice,
      'quantity': quantity,
      'is_paid': isPaid,
      'paid_by_user_id': paidByUserId,
      'paid_at': paidAt?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  BillItem copyWith({
    String? id,
    String? billId,
    String? name,
    double? unitPrice,
    int? quantity,
    bool? isPaid,
    String? paidByUserId,
    DateTime? paidAt,
  }) {
    return BillItem(
      id: id ?? this.id,
      billId: billId ?? this.billId,
      name: name ?? this.name,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      isPaid: isPaid ?? this.isPaid,
      paidByUserId: paidByUserId ?? this.paidByUserId,
      paidAt: paidAt ?? this.paidAt,
    );
  }
}

