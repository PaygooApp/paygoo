import 'package:paygoo/models/table_info.dart';

/// Mock table data for MVP testing
class TableMock {
  TableMock._();

  /// Table 7 at Taverna Racilor - has active bill
  static const TableInfo tavernaTable7 = TableInfo(
    id: 'table_001',
    restaurantId: 'rest_001',
    tableNumber: 7,
    token: 'valid-with-bill',
  );

  /// Table 12 at Restaurant Exemplu - no active bill
  static const TableInfo exempluTable12 = TableInfo(
    id: 'table_002',
    restaurantId: 'rest_002',
    tableNumber: 12,
    token: 'valid-no-bill',
  );

  /// Terrace table with custom name
  static const TableInfo tavernaTerrace1 = TableInfo(
    id: 'table_003',
    restaurantId: 'rest_001',
    tableNumber: 1,
    token: 'valid-terrace',
    displayName: 'Terrace 1',
  );

  static const List<TableInfo> allTables = [
    tavernaTable7,
    exempluTable12,
    tavernaTerrace1,
  ];

  /// Find table by token
  static TableInfo? findByToken(String token) {
    try {
      return allTables.firstWhere((t) => t.token == token);
    } catch (_) {
      return null;
    }
  }
}

