import 'package:paygoo/models/order_item.dart';

class OrderItemsMock {
  static const List<OrderItem> items = [
    OrderItem(
      id: '1',
      name: 'Margherita Pizza',
      price: '\$12.99',
      priceValue: 12.99,
      availableQuantity: 5,
    ),
    OrderItem(
      id: '2',
      name: 'Caesar Salad',
      price: '\$8.50',
      priceValue: 8.50,
      availableQuantity: 3,
    ),
    OrderItem(
      id: '3',
      name: 'Grilled Salmon',
      price: '\$18.75',
      priceValue: 18.75,
      availableQuantity: 2,
    ),
    OrderItem(
      id: '4',
      name: 'Tiramisu',
      price: '\$6.50',
      priceValue: 6.50,
      availableQuantity: 4,
    ),
    OrderItem(
      id: '5',
      name: 'Heineken',
      price: '\$3.50',
      priceValue: 3.50,
      availableQuantity: 4,
    ),
    OrderItem(
      id: '6',
      name: 'Carlsberg',
      price: '\$2.50',
      priceValue: 2.50,
      availableQuantity: 10,
    ),
    OrderItem(
      id: '7',
      name: 'American pie',
      price: '\$12.50',
      priceValue: 12.50,
      availableQuantity: 2,
    ),
    OrderItem(
      id: '8',
      name: 'Vin Issa',
      price: '\$20.50',
      priceValue: 20.50,
      availableQuantity: 1,
    ),
    OrderItem(
      id: '9',
      name: 'Vin Chardonai',
      price: '\$20.50',
      priceValue: 20.50,
      availableQuantity: 1,
    ),
    OrderItem(
      id: '10',
      name: 'Rabdari prajite',
      price: '\$10.50',
      priceValue: 10.50,
      availableQuantity: 4,
    ),
    OrderItem(
      id: '11',
      name: 'Placinta pe vatra',
      price: '\$5.00',
      priceValue: 5.00,
      availableQuantity: 2,
    ),
  ];
}
