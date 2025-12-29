/// Represents a currency with its symbol and formatting rules
class Currency {
  final String code;
  final String symbol;
  final bool symbolAfterAmount;
  final int decimalPlaces;

  const Currency({
    required this.code,
    required this.symbol,
    this.symbolAfterAmount = false,
    this.decimalPlaces = 2,
  });

  /// Formats an amount according to this currency's rules
  String format(double amount) {
    final formattedAmount = amount.toStringAsFixed(decimalPlaces);
    if (symbolAfterAmount) {
      return '$formattedAmount $symbol';
    }
    return '$symbol$formattedAmount';
  }

  /// US Dollar
  static const Currency usd = Currency(
    code: 'USD',
    symbol: '\$',
  );

  /// Romanian Leu
  static const Currency ron = Currency(
    code: 'RON',
    symbol: 'Lei',
    symbolAfterAmount: true,
  );

  /// Euro
  static const Currency eur = Currency(
    code: 'EUR',
    symbol: '€',
  );

  /// British Pound
  static const Currency gbp = Currency(
    code: 'GBP',
    symbol: '£',
  );
}

