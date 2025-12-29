import 'package:flutter/material.dart';
import 'package:paygoo/components/atoms/wave_paper_clipper.dart';
import 'package:paygoo/components/wrappers/order_item_card.dart';
import 'package:paygoo/models/order_item.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

class OrderItemsGroupedLayout extends StatelessWidget {
  final List<OrderItem> items;
  final Map<String, OrderItemSelection> selections;
  final void Function(String itemId, bool isSelected) onSelectedChanged;
  final void Function(String itemId, int quantity) onQuantityChanged;

  const OrderItemsGroupedLayout({
    super.key,
    required this.items,
    required this.selections,
    required this.onSelectedChanged,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return WavePaperContainer(
      color: Theme.of(context).colorScheme.surface,
      waveHeight: 10,
      waveWidth: 20,
      topRadius: 16,
      boxShadow: [
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 6,
          offset: Offset(0, -2),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Color(0x10000000),
          blurRadius: 8,
          offset: Offset(0, 3),
          spreadRadius: 0,
        ),
      ],
      child: Column(
        children: [
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final selection = selections[item.id]!;
            final isLast = index == items.length - 1;
            return Column(
              children: [
                OrderItemCard(
                  itemName: item.name,
                  price: item.price,
                  isSelected: selection.isSelected,
                  onSelectedChanged: (value) =>
                      onSelectedChanged(item.id, value),
                  availableQuantity: item.availableQuantity,
                  selectedQuantity: selection.selectedQuantity,
                  onQuantityChanged: (value) =>
                      onQuantityChanged(item.id, value),
                  showSelectedBorder: false,
                  enableTapAnimation: true,
                  layoutStyle: OrderItemLayoutStyle.grouped,
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: TokenPrimitiveMode1.gray200,
                    indent: 0,
                    endIndent: 0,
                  ),
                if (isLast) SizedBox(height: 14),
              ],
            );
          }),
        ],
      ),
    );
  }
}

