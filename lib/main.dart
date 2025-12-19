import 'package:flutter/material.dart';
import 'package:paygoo/utils/theme/theme.dart';

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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paygoo")),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  "\$24.5",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: .w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
