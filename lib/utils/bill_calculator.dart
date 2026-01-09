import 'package:paygoo/models/bill.dart';
import 'package:paygoo/providers/bill_selections_provider.dart';

/// Calculator for bill totals based on selections.
class BillCalculator {
  final Bill bill;
  final Map<String, BillItemSelection> selections;

  const BillCalculator({
    required this.bill,
    required this.selections,
  });

  /// Calculate total for selected items only
  double get selectedTotal {
    double total = 0;
    for (final item in bill.unpaidItems) {
      final selection = selections[item.id];
      if (selection != null && selection.isSelected) {
        total += item.unitPrice * selection.selectedQuantity;
      }
    }
    return total;
  }

  /// Calculate total for all unpaid items
  double get unpaidTotal {
    double total = 0;
    for (final item in bill.unpaidItems) {
      total += item.totalPrice;
    }
    return total;
  }

  /// Number of selected items
  int get selectedItemCount {
    int count = 0;
    for (final item in bill.unpaidItems) {
      final selection = selections[item.id];
      if (selection != null && selection.isSelected) {
        count += selection.selectedQuantity;
      }
    }
    return count;
  }

  /// Number of total unpaid items
  int get totalUnpaidItemCount {
    int count = 0;
    for (final item in bill.unpaidItems) {
      count += item.quantity;
    }
    return count;
  }

  /// Calculate tip amount based on percentage
  double tipAmount(double percentage) {
    return selectedTotal * (percentage / 100);
  }

  /// Calculate grand total with tip
  double grandTotal(double tipPercentage) {
    return selectedTotal + tipAmount(tipPercentage);
  }
}

