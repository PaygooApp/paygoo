import 'package:paygoo/components/atoms/option_card_selector.dart';

class TipConstants {
  TipConstants._();

  /// Index of the custom tip option in the list
  static const int customTipIndex = 3;

  static const List<int> tipPercentages = [5, 10, 15];

  static const List<OptionCardItem> defaultTipOptions = [
    OptionCardItem(emoji: '😎', label: '5%', value: 5),
    OptionCardItem(emoji: '🎉', label: '10%', value: 10),
    OptionCardItem(emoji: '🔥', label: '15%', value: 15),
    OptionCardItem(emoji: '✏️', label: 'Custom', value: null),
  ];

  static List<OptionCardItem> buildTipOptions({double? customTipPercentage}) {
    return [
      const OptionCardItem(emoji: '😎', label: '5%', value: 5),
      const OptionCardItem(emoji: '🎉', label: '10%', value: 10),
      const OptionCardItem(emoji: '🔥', label: '15%', value: 15),
      OptionCardItem(
        emoji: '✏️',
        label: customTipPercentage != null
            ? '${customTipPercentage.round()}%'
            : 'Custom',
        value: null,
      ),
    ];
  }
}
