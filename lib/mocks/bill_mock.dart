import 'package:paygoo/models/bill.dart';
import 'package:paygoo/models/bill_item.dart';

/// Mock bill data for MVP testing
class BillMock {
  BillMock._();

  /// Active bill for Table 7 at Taverna Racilor
  static final Bill tavernaTable7Bill = Bill(
    id: 'bill_001',
    tableId: 'table_001',
    status: BillStatus.open,
    totalAmount: 263.17,
    paidAmount: 0,
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
    version: 1,
    items: [
      const BillItem(
        id: 'item_001',
        billId: 'bill_001',
        name: 'Margherita Pizza',
        unitPrice: 12.99,
        quantity: 2,
      ),
      const BillItem(
        id: 'item_002',
        billId: 'bill_001',
        name: 'Caesar Salad',
        unitPrice: 8.50,
        quantity: 1,
      ),
      const BillItem(
        id: 'item_003',
        billId: 'bill_001',
        name: 'Grilled Salmon',
        unitPrice: 18.75,
        quantity: 2,
      ),
      const BillItem(
        id: 'item_004',
        billId: 'bill_001',
        name: 'Tiramisu',
        unitPrice: 6.50,
        quantity: 3,
      ),
      const BillItem(
        id: 'item_005',
        billId: 'bill_001',
        name: 'Heineken Beer',
        unitPrice: 3.50,
        quantity: 4,
      ),
      const BillItem(
        id: 'item_006',
        billId: 'bill_001',
        name: 'House Wine (Glass)',
        unitPrice: 7.00,
        quantity: 2,
      ),
      const BillItem(
        id: 'item_007',
        billId: 'bill_001',
        name: 'Rabdari Prajite',
        unitPrice: 10.50,
        quantity: 1,
      ),
      const BillItem(
        id: 'item_008',
        billId: 'bill_001',
        name: 'Placinta pe Vatra',
        unitPrice: 5.00,
        quantity: 2,
      ),
      const BillItem(
        id: 'item_009',
        billId: 'bill_001',
        name: 'Sparkling Water',
        unitPrice: 2.50,
        quantity: 3,
      ),
      const BillItem(
        id: 'item_010',
        billId: 'bill_001',
        name: 'Espresso',
        unitPrice: 3.00,
        quantity: 4,
      ),
    ],
  );

  /// Partially paid bill example
  static final Bill partiallyPaidBill = Bill(
    id: 'bill_002',
    tableId: 'table_003',
    status: BillStatus.partial,
    totalAmount: 150.00,
    paidAmount: 50.00,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    updatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
    version: 3,
    items: [
      BillItem(
        id: 'item_101',
        billId: 'bill_002',
        name: 'Steak',
        unitPrice: 25.00,
        quantity: 2,
        isPaid: true,
        paidByUserId: 'user_001',
        paidAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      const BillItem(
        id: 'item_102',
        billId: 'bill_002',
        name: 'Pasta Carbonara',
        unitPrice: 15.00,
        quantity: 2,
      ),
      const BillItem(
        id: 'item_103',
        billId: 'bill_002',
        name: 'Wine Bottle',
        unitPrice: 40.00,
        quantity: 1,
      ),
      const BillItem(
        id: 'item_104',
        billId: 'bill_002',
        name: 'Dessert Platter',
        unitPrice: 20.00,
        quantity: 1,
      ),
    ],
  );

  static final List<Bill> allBills = [
    tavernaTable7Bill,
    partiallyPaidBill,
  ];

  /// Find bill by table ID
  static Bill? findByTableId(String tableId) {
    try {
      return allBills.firstWhere((b) => b.tableId == tableId);
    } catch (_) {
      return null;
    }
  }
}

