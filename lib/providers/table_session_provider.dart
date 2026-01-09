import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paygoo/models/bill.dart';
import 'package:paygoo/models/table_session.dart';
import 'package:paygoo/mocks/table_session_mock.dart';

/// State wrapper for table session with loading/error states
sealed class TableSessionState {
  const TableSessionState();
}

/// Initial state - no token has been provided yet
class TableSessionInitial extends TableSessionState {
  const TableSessionInitial();
}

/// Loading state - resolving token
class TableSessionLoading extends TableSessionState {
  final String token;
  const TableSessionLoading(this.token);
}

/// Loaded state - token resolved successfully or failed
class TableSessionLoaded extends TableSessionState {
  final TableSession session;
  const TableSessionLoaded(this.session);
}

/// Error state - network or unexpected error
class TableSessionError extends TableSessionState {
  final String message;
  final String? token;
  const TableSessionError(this.message, {this.token});
}

/// Notifier for managing table session state
class TableSessionNotifier extends Notifier<TableSessionState> {
  @override
  TableSessionState build() {
    return const TableSessionInitial();
  }

  /// Resolve a token from QR code scan
  Future<void> resolveToken(String token) async {
    // Set loading state
    state = TableSessionLoading(token);

    try {
      // For MVP, use mock service. Later, this will call Supabase.
      final session = await TableSessionMock.resolveToken(token);
      state = TableSessionLoaded(session);

      // If session is valid, set up real-time subscription (future)
      if (session.isValid) {
        _subscribeToUpdates(session);
      }
    } catch (e) {
      state = TableSessionError(
        'Failed to load table information. Please try again.',
        token: token,
      );
    }
  }

  /// Handle real-time bill update from WebSocket
  void onBillUpdated(Bill updatedBill) {
    final currentState = state;
    if (currentState is TableSessionLoaded) {
      final session = currentState.session;
      if (session.isValid) {
        state = TableSessionLoaded(session.copyWithBill(updatedBill));
      }
    }
  }

  /// Subscribe to real-time updates for this table
  /// In production, this will use Supabase Realtime
  void _subscribeToUpdates(TableSession session) {
    // TODO: Implement Supabase Realtime subscription
    // final channel = supabase.channel('table:${session.token}');
    // channel.onPostgresChanges(
    //   event: PostgresChangeEvent.all,
    //   schema: 'public',
    //   table: 'bills',
    //   filter: PostgresChangeFilter(
    //     type: PostgresChangeFilterType.eq,
    //     column: 'table_id',
    //     value: session.table!.id,
    //   ),
    //   callback: (payload) {
    //     final updatedBill = Bill.fromJson(payload.newRecord);
    //     onBillUpdated(updatedBill);
    //   },
    // );
    // channel.subscribe();
  }

  /// Unsubscribe from real-time updates
  void _unsubscribeFromUpdates() {
    // TODO: Implement unsubscribe
    // supabase.removeChannel(channel);
  }

  /// Clear session (e.g., when user leaves or scans new QR)
  void clearSession() {
    _unsubscribeFromUpdates();
    state = const TableSessionInitial();
  }

  /// Retry loading with the same token
  Future<void> retry() async {
    final currentState = state;
    String? token;

    if (currentState is TableSessionLoading) {
      token = currentState.token;
    } else if (currentState is TableSessionError) {
      token = currentState.token;
    } else if (currentState is TableSessionLoaded) {
      token = currentState.session.token;
    }

    if (token != null) {
      await resolveToken(token);
    }
  }
}

/// Provider for table session state
final tableSessionProvider =
    NotifierProvider<TableSessionNotifier, TableSessionState>(
  TableSessionNotifier.new,
);

/// Convenience provider to get current session if loaded
final currentTableSessionProvider = Provider<TableSession?>((ref) {
  final state = ref.watch(tableSessionProvider);
  if (state is TableSessionLoaded) {
    return state.session;
  }
  return null;
});

/// Provider to check if session has a bill
final hasBillProvider = Provider<bool>((ref) {
  final session = ref.watch(currentTableSessionProvider);
  return session?.hasBill ?? false;
});

