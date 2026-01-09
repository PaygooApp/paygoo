import 'package:paygoo/models/bill.dart';
import 'package:paygoo/models/restaurant.dart';
import 'package:paygoo/models/table_info.dart';

/// The result of resolving a table token.
/// Represents the current state of a table session.
enum TableSessionStatus {
  /// Token is valid, table exists, and there's an active bill
  validWithBill,

  /// Token is valid, table exists, but no active bill
  validNoBill,

  /// Token is invalid or expired
  invalid,
}

/// Represents a resolved table session from a QR code scan.
/// This is the main model returned after token resolution.
class TableSession {
  final String token;
  final TableSessionStatus status;
  final Restaurant? restaurant;
  final TableInfo? table;
  final Bill? bill;
  final String? errorMessage;
  final DateTime resolvedAt;

  const TableSession({
    required this.token,
    required this.status,
    this.restaurant,
    this.table,
    this.bill,
    this.errorMessage,
    required this.resolvedAt,
  });

  /// Check if session is valid (either with or without bill)
  bool get isValid => status != TableSessionStatus.invalid;

  /// Check if session has an active bill
  bool get hasBill => status == TableSessionStatus.validWithBill && bill != null;

  /// Factory for creating an invalid session
  factory TableSession.invalid({
    required String token,
    String? errorMessage,
  }) {
    return TableSession(
      token: token,
      status: TableSessionStatus.invalid,
      errorMessage: errorMessage ?? 'Invalid or expired table token',
      resolvedAt: DateTime.now(),
    );
  }

  /// Factory for creating a valid session without bill
  factory TableSession.validNoBill({
    required String token,
    required Restaurant restaurant,
    required TableInfo table,
  }) {
    return TableSession(
      token: token,
      status: TableSessionStatus.validNoBill,
      restaurant: restaurant,
      table: table,
      resolvedAt: DateTime.now(),
    );
  }

  /// Factory for creating a valid session with bill
  factory TableSession.validWithBill({
    required String token,
    required Restaurant restaurant,
    required TableInfo table,
    required Bill bill,
  }) {
    return TableSession(
      token: token,
      status: TableSessionStatus.validWithBill,
      restaurant: restaurant,
      table: table,
      bill: bill,
      resolvedAt: DateTime.now(),
    );
  }

  /// Create a copy with an updated bill (for real-time updates)
  TableSession copyWithBill(Bill newBill) {
    return TableSession(
      token: token,
      status: TableSessionStatus.validWithBill,
      restaurant: restaurant,
      table: table,
      bill: newBill,
      resolvedAt: resolvedAt,
    );
  }

  factory TableSession.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status'] as String;
    final status = TableSessionStatus.values.firstWhere(
      (e) => e.name == statusStr,
      orElse: () => TableSessionStatus.invalid,
    );

    return TableSession(
      token: json['token'] as String,
      status: status,
      restaurant: json['restaurant'] != null
          ? Restaurant.fromJson(json['restaurant'] as Map<String, dynamic>)
          : null,
      table: json['table'] != null
          ? TableInfo.fromJson(json['table'] as Map<String, dynamic>)
          : null,
      bill: json['bill'] != null
          ? Bill.fromJson(json['bill'] as Map<String, dynamic>)
          : null,
      errorMessage: json['error_message'] as String?,
      resolvedAt: DateTime.parse(json['resolved_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'status': status.name,
      'restaurant': restaurant?.toJson(),
      'table': table?.toJson(),
      'bill': bill?.toJson(),
      'error_message': errorMessage,
      'resolved_at': resolvedAt.toIso8601String(),
    };
  }
}

