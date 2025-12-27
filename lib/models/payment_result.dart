/// Model representing a payment result from the API.
class PaymentResult {
  /// The order ID
  final String orderId;

  /// The payment time formatted string
  final String paymentTime;

  /// The payment method display string
  final String paymentMethod;

  /// The subtotal amount before tips
  final double subtotal;

  /// The tips amount
  final double tips;

  /// The total amount (subtotal + tips)
  final double total;

  /// Whether the payment was successful
  final bool isSuccessful;

  /// Currency symbol
  final String currencySymbol;

  const PaymentResult({
    required this.orderId,
    required this.paymentTime,
    required this.paymentMethod,
    required this.subtotal,
    required this.tips,
    required this.total,
    this.isSuccessful = true,
    this.currencySymbol = '€',
  });
}

