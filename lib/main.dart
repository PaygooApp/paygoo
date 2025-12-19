import 'package:flutter/material.dart';
import 'package:paygoo/components/wrappers/venu_table_card.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';
import 'package:paygoo/utils/theme/theme.dart';
import 'package:paygoo/components/atoms/app_checkbox.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
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
  bool isChecked = false;
  bool isCircularChecked = false;

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
              SizedBox(height: 28),
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
              SizedBox(height: 28),
              AppCheckbox(
                value: isChecked,
                onChanged: (value) => setState(() => isChecked = value),
                label: "Rectangular (default)",
              ),
              SizedBox(height: 16),
              AppCheckbox(
                value: isCircularChecked,
                onChanged: (value) => setState(() => isCircularChecked = value),
                label: "Circular",
                style: AppCheckboxStyle.circular,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
