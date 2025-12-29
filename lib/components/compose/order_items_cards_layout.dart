import 'package:flutter/material.dart';
import 'package:paygoo/components/wrappers/order_item_card.dart';
import 'package:paygoo/models/order_item.dart';

class OrderItemsCardsLayout extends StatelessWidget {
  final List<OrderItem> items;
  final Map<String, OrderItemSelection> selections;
  final void Function(String itemId, bool isSelected) onSelectedChanged;
  final void Function(String itemId, int quantity) onQuantityChanged;

  const OrderItemsCardsLayout({
    super.key,
    required this.items,
    required this.selections,
    required this.onSelectedChanged,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...items.map((item) {
          final selection = selections[item.id]!;
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: OrderItemCard(
              itemName: item.name,
              price: item.price,
              isSelected: selection.isSelected,
              onSelectedChanged: (value) => onSelectedChanged(item.id, value),
              availableQuantity: item.availableQuantity,
              selectedQuantity: selection.selectedQuantity,
              onQuantityChanged: (value) => onQuantityChanged(item.id, value),
              showSelectedBorder: false,
              enableTapAnimation: true,
              layoutStyle: OrderItemLayoutStyle.cards,
            ),
          );
        }),
      ],
    );
  }
}

