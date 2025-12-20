import 'package:flutter/material.dart';
import 'package:paygoo/components/compose/order_item_card.dart';
import 'package:paygoo/components/wrappers/venu_table_card.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';
import 'package:paygoo/utils/theme/theme.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isItem1Selected = false;
  bool isItem2Selected = false;
  // Available quantities (max)
  static const int item1Available = 5;
  static const int item2Available = 3;
  // Selected quantities (1 to available, used when active)
  int item1Selected = 1;
  int item2Selected = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paygoo")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              VenueTableCard(
                venueLogo: "venueLogo",
                venueName: "Taverna Racilor",
                tableNumber: "Table:8",
                totalAmount: "\$55.50",
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pay Your Bill",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    "View History",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: TokenPrimitiveMode1.gray300,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // With animation, no border
              OrderItemCard(
                itemName: "Margherita Pizza",
                price: "\$12.99",
                isSelected: isItem1Selected,
                onSelectedChanged: (value) =>
                    setState(() => isItem1Selected = value),
                availableQuantity: item1Available,
                selectedQuantity: item1Selected,
                onQuantityChanged: (value) =>
                    setState(() => item1Selected = value),
                showSelectedBorder: false,
                enableTapAnimation: true,
              ),
              SizedBox(height: 6),
              // No animation, no border
              OrderItemCard(
                itemName: "Caesar Salad",
                price: "\$8.50",
                isSelected: isItem2Selected,
                onSelectedChanged: (value) =>
                    setState(() => isItem2Selected = value),
                availableQuantity: item2Available,
                selectedQuantity: item2Selected,
                onQuantityChanged: (value) =>
                    setState(() => item2Selected = value),
                showSelectedBorder: false,
                enableTapAnimation: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
