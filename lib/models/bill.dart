import 'package:paygoo/models/bill_item.dart';

/// Status of a bill
enum BillStatus {
  open,      // Bill is active, can add items or pay
  partial,   // Some items have been paid
  paid,      // Fully paid
  closed,    // Closed by restaurant
}

/// Model representing a bill/order for a table.
/// This is synced in real-time via Supabase Realtime.
class Bill {
  final String id;
  final String tableId;
  final List<BillItem> items;
  final BillStatus status;
  final double totalAmount;
  final double paidAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version; // For optimistic locking in real-time sync

  const Bill({
    required this.id,
    required this.tableId,
    required this.items,
    required this.status,
    required this.totalAmount,
    required this.paidAmount,
    required this.createdAt,
    required this.updatedAt,
    this.version = 1,
  });

  /// Remaining amount to be paid
  double get remainingAmount => totalAmount - paidAmount;

  /// Check if bill is fully paid
  bool get isFullyPaid => remainingAmount <= 0;

  /// Get unpaid items
  List<BillItem> get unpaidItems =>
      items.where((item) => !item.isPaid).toList();

  /// Get paid items
  List<BillItem> get paidItems =>
      items.where((item) => item.isPaid).toList();

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'] as String,
      tableId: json['table_id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => BillItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      status: BillStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BillStatus.open,
      ),
      totalAmount: (json['total_amount'] as num).toDouble(),
      paidAmount: (json['paid_amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      version: json['version'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'table_id': tableId,
      'items': items.map((item) => item.toJson()).toList(),
      'status': status.name,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'version': version,
    };
  }

  /// Create a copy with updated fields (for real-time updates)
  Bill copyWith({
    String? id,
    String? tableId,
    List<BillItem>? items,
    BillStatus? status,
    double? totalAmount,
    double? paidAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return Bill(
      id: id ?? this.id,
      tableId: tableId ?? this.tableId,
      items: items ?? this.items,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}

