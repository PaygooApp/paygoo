/// Model representing a table in a restaurant.
/// Each table has a unique token used in QR codes.
class TableInfo {
  final String id;
  final String restaurantId;
  final int tableNumber;
  final String token; // Unique token for QR code
  final String? displayName; // Optional custom name like "Terrace 1"

  const TableInfo({
    required this.id,
    required this.restaurantId,
    required this.tableNumber,
    required this.token,
    this.displayName,
  });

  /// Returns display string for the table (e.g., "Table 7" or "Terrace 1")
  String get displayLabel => displayName ?? 'Table $tableNumber';

  factory TableInfo.fromJson(Map<String, dynamic> json) {
    return TableInfo(
      id: json['id'] as String,
      restaurantId: json['restaurant_id'] as String,
      tableNumber: json['table_number'] as int,
      token: json['token'] as String,
      displayName: json['display_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'table_number': tableNumber,
      'token': token,
      'display_name': displayName,
    };
  }
}

