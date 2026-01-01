/// UI strings model - all translatable strings come from backend
/// This class is immutable and JSON-serializable
class UiStrings {
  const UiStrings({
    // Home screen
    this.payYourBill = 'Pay Your Bill',
    this.selectAll = 'Select All',
    this.deselectAll = 'Deselect All',
    this.paymentMethods = 'Payment Methods',
    
    // Tips
    this.addTips = 'Add tips',
    this.optional = '(optional)',
    this.serviceFee = 'Service Fee',
    this.tipAmount = 'Tip Amount',
    this.custom = 'Custom',
    
    // Payment
    this.swipeToPay = 'Swipe to pay',
    this.processing = 'Processing...',
    
    // Payment result
    this.paymentSuccessful = 'Payment Successful',
    this.paymentFailed = 'Payment Failed',
    this.thankYou = 'Thank you for your payment!',
    this.tryAgain = 'Try Again',
    this.backToHome = 'Back to Home',
    
    // General
    this.loading = 'Loading...',
    this.error = 'An error occurred',
    this.retry = 'Retry',
    this.cancel = 'Cancel',
    this.confirm = 'Confirm',
    this.done = 'Done',
  });

  // Home screen
  final String payYourBill;
  final String selectAll;
  final String deselectAll;
  final String paymentMethods;

  // Tips
  final String addTips;
  final String optional;
  final String serviceFee;
  final String tipAmount;
  final String custom;

  // Payment
  final String swipeToPay;
  final String processing;

  // Payment result
  final String paymentSuccessful;
  final String paymentFailed;
  final String thankYou;
  final String tryAgain;
  final String backToHome;

  // General
  final String loading;
  final String error;
  final String retry;
  final String cancel;
  final String confirm;
  final String done;

  /// Create from JSON (backend response)
  factory UiStrings.fromJson(Map<String, dynamic> json) {
    return UiStrings(
      // Home screen
      payYourBill: json['pay_your_bill'] as String? ?? 'Pay Your Bill',
      selectAll: json['select_all'] as String? ?? 'Select All',
      deselectAll: json['deselect_all'] as String? ?? 'Deselect All',
      paymentMethods: json['payment_methods'] as String? ?? 'Payment Methods',
      
      // Tips
      addTips: json['add_tips'] as String? ?? 'Add tips',
      optional: json['optional'] as String? ?? '(optional)',
      serviceFee: json['service_fee'] as String? ?? 'Service Fee',
      tipAmount: json['tip_amount'] as String? ?? 'Tip Amount',
      custom: json['custom'] as String? ?? 'Custom',
      
      // Payment
      swipeToPay: json['swipe_to_pay'] as String? ?? 'Swipe to pay',
      processing: json['processing'] as String? ?? 'Processing...',
      
      // Payment result
      paymentSuccessful: json['payment_successful'] as String? ?? 'Payment Successful',
      paymentFailed: json['payment_failed'] as String? ?? 'Payment Failed',
      thankYou: json['thank_you'] as String? ?? 'Thank you for your payment!',
      tryAgain: json['try_again'] as String? ?? 'Try Again',
      backToHome: json['back_to_home'] as String? ?? 'Back to Home',
      
      // General
      loading: json['loading'] as String? ?? 'Loading...',
      error: json['error'] as String? ?? 'An error occurred',
      retry: json['retry'] as String? ?? 'Retry',
      cancel: json['cancel'] as String? ?? 'Cancel',
      confirm: json['confirm'] as String? ?? 'Confirm',
      done: json['done'] as String? ?? 'Done',
    );
  }

  /// Convert to JSON (for caching)
  Map<String, dynamic> toJson() {
    return {
      'pay_your_bill': payYourBill,
      'select_all': selectAll,
      'deselect_all': deselectAll,
      'payment_methods': paymentMethods,
      'add_tips': addTips,
      'optional': optional,
      'service_fee': serviceFee,
      'tip_amount': tipAmount,
      'custom': custom,
      'swipe_to_pay': swipeToPay,
      'processing': processing,
      'payment_successful': paymentSuccessful,
      'payment_failed': paymentFailed,
      'thank_you': thankYou,
      'try_again': tryAgain,
      'back_to_home': backToHome,
      'loading': loading,
      'error': error,
      'retry': retry,
      'cancel': cancel,
      'confirm': confirm,
      'done': done,
    };
  }

  /// Default English strings (fallback)
  static const UiStrings fallback = UiStrings();
}

