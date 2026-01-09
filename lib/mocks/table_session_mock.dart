import 'package:paygoo/models/table_session.dart';
import 'package:paygoo/mocks/restaurant_mock.dart';
import 'package:paygoo/mocks/table_mock.dart';
import 'package:paygoo/mocks/bill_mock.dart';

/// Mock service for resolving table tokens.
/// In production, this will be replaced with Supabase calls.
class TableSessionMock {
  TableSessionMock._();

  /// Simulated network delay for realistic testing
  static const Duration mockNetworkDelay = Duration(milliseconds: 800);

  /// Resolve a token and return the appropriate TableSession.
  /// 
  /// Test tokens:
  /// - `valid-with-bill` → Table 7 at Taverna Racilor with active bill
  /// - `valid-no-bill` → Table 12 at Restaurant Exemplu with no bill
  /// - `valid-terrace` → Terrace 1 at Taverna Racilor (partial bill)
  /// - Any other token → Invalid (404)
  static Future<TableSession> resolveToken(String token) async {
    // Simulate network delay
    await Future.delayed(mockNetworkDelay);

    switch (token) {
      case 'valid-with-bill':
        return TableSession.validWithBill(
          token: token,
          restaurant: RestaurantMock.tavernaRacilor,
          table: TableMock.tavernaTable7,
          bill: BillMock.tavernaTable7Bill,
        );

      case 'valid-no-bill':
        return TableSession.validNoBill(
          token: token,
          restaurant: RestaurantMock.restaurantExemplu,
          table: TableMock.exempluTable12,
        );

      case 'valid-terrace':
        return TableSession.validWithBill(
          token: token,
          restaurant: RestaurantMock.tavernaRacilor,
          table: TableMock.tavernaTerrace1,
          bill: BillMock.partiallyPaidBill,
        );

      default:
        return TableSession.invalid(
          token: token,
          errorMessage: 'Table not found. Please scan a valid QR code.',
        );
    }
  }

  /// Get all valid test tokens for debugging
  static List<String> get validTestTokens => [
    'valid-with-bill',
    'valid-no-bill',
    'valid-terrace',
  ];

  /// Get an example invalid token
  static String get invalidTestToken => 'invalid-token-xyz';
}

