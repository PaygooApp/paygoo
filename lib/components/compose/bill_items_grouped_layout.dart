import 'package:flutter/material.dart';
import 'package:paygoo/components/atoms/wave_paper_clipper.dart';
import 'package:paygoo/components/wrappers/order_item_card.dart';
import 'package:paygoo/models/bill_item.dart';
import 'package:paygoo/providers/bill_selections_provider.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// Layout for displaying bill items in a grouped receipt style.
class BillItemsGroupedLayout extends StatelessWidget {
  final List<BillItem> items;
  final Map<String, BillItemSelection> selections;
  final void Function(String itemId, bool isSelected) onSelectedChanged;
  final void Function(String itemId, int quantity) onQuantityChanged;

  const BillItemsGroupedLayout({
    super.key,
    required this.items,
    required this.selections,
    required this.onSelectedChanged,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _buildEmptyState(context);
    }

    return WavePaperContainer(
      color: Theme.of(context).colorScheme.surface,
      waveHeight: 10,
      waveWidth: 20,
      topRadius: 16,
      boxShadow: const [
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
            final selection = selections[item.id] ?? const BillItemSelection();
            final isLast = index == items.length - 1;

            return Column(
              children: [
                OrderItemCard(
                  itemName: item.name,
                  price: item.formattedUnitPrice,
                  isSelected: selection.isSelected,
                  onSelectedChanged: (value) =>
                      onSelectedChanged(item.id, value),
                  availableQuantity: item.quantity,
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
                if (isLast) const SizedBox(height: 14),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'All items paid!',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thank you for dining with us.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

