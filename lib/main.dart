import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paygoo/screens/token_test_screen.dart';
import 'package:paygoo/utils/theme/theme.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      // For MVP testing, start with the token test screen
      // In production, this will handle deep links from QR codes
      home: const TokenTestScreen(),
    );
  }
}
