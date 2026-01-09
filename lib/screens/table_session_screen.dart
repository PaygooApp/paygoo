import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paygoo/components/wrappers/order_item_card.dart';
import 'package:paygoo/models/table_session.dart';
import 'package:paygoo/providers/table_session_provider.dart';
import 'package:paygoo/screens/bill_screen.dart';
import 'package:paygoo/screens/table_error_screen.dart';
import 'package:paygoo/screens/table_loading_screen.dart';
import 'package:paygoo/screens/welcome_screen.dart';

/// Main entry screen that handles table session routing.
/// This screen automatically shows the correct UI based on token resolution state.
class TableSessionScreen extends ConsumerStatefulWidget {
  final String token;

  const TableSessionScreen({super.key, required this.token});

  @override
  ConsumerState<TableSessionScreen> createState() => _TableSessionScreenState();
}

class _TableSessionScreenState extends ConsumerState<TableSessionScreen> {
  @override
  void initState() {
    super.initState();
    // Resolve token when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tableSessionProvider.notifier).resolveToken(widget.token);
    });
  }

  void _handleRetry() {
    ref.read(tableSessionProvider.notifier).retry();
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(tableSessionProvider);

    return switch (sessionState) {
      TableSessionInitial() => const TableLoadingScreen(),
      TableSessionLoading() => const TableLoadingScreen(),
      TableSessionError(:final message) => TableErrorScreen(
        errorMessage: message,
        onRetry: _handleRetry,
      ),
      TableSessionLoaded(:final session) => _buildSessionScreen(session),
    };
  }

  Widget _buildSessionScreen(TableSession session) {
    return switch (session.status) {
      TableSessionStatus.invalid => TableErrorScreen(
        errorMessage: session.errorMessage ?? 'Invalid table',
        onRetry: _handleRetry,
      ),
      TableSessionStatus.validNoBill => const WelcomeScreen(),
      TableSessionStatus.validWithBill => BillScreen(
        session: session,
        orderItemLayoutStyle: OrderItemLayoutStyle.grouped,
      ),
    };
  }
}
