import 'package:paygoo/models/payment_result.dart';

/// Mock data for payment results.
/// This will be replaced with actual API responses in the future.
class PaymentResultMock {
  /// A successful payment result mock
  static const PaymentResult successfulPayment = PaymentResult(
    orderId: '#ORD-2024-001234',
    paymentTime: 'Dec 27, 2024 at 14:32',
    paymentMethod: 'Visa •••• 4242',
    subtotal: 110.00,
    tips: 15.50,
    total: 125.50,
    isSuccessful: true,
    currencySymbol: '€',
  );

  /// A failed payment result mock
  static const PaymentResult failedPayment = PaymentResult(
    orderId: '#ORD-2024-001235',
    paymentTime: 'Dec 27, 2024 at 14:45',
    paymentMethod: 'Visa •••• 4242',
    subtotal: 85.00,
    tips: 10.00,
    total: 95.00,
    isSuccessful: false,
    currencySymbol: '€',
  );
}

