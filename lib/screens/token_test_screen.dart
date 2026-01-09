import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paygoo/mocks/table_session_mock.dart';
import 'package:paygoo/screens/table_session_screen.dart';

/// Test screen for manually testing different token scenarios.
/// This simulates scanning different QR codes.
class TokenTestScreen extends StatelessWidget {
  const TokenTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Paygoo QR Test'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Test QR Code Scenarios',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap a button below to simulate scanning a QR code with that token.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 32),

              // Valid with bill
              _TestButton(
                icon: Icons.receipt_long,
                title: 'Valid - With Bill',
                subtitle:
                    'Table 7 at Taverna Racilor\n10 items, \$263.17 total',
                color: Colors.green,
                token: 'valid-with-bill',
              ),
              const SizedBox(height: 16),

              // Valid without bill
              _TestButton(
                icon: Icons.table_restaurant,
                title: 'Valid - No Bill',
                subtitle: 'Table 12 at Restaurant Exemplu\nNo active order yet',
                color: Colors.blue,
                token: 'valid-no-bill',
              ),
              const SizedBox(height: 16),

              // Partially paid bill
              _TestButton(
                icon: Icons.payments_outlined,
                title: 'Valid - Partial Bill',
                subtitle:
                    'Terrace 1 at Taverna Racilor\nSome items already paid',
                color: Colors.orange,
                token: 'valid-terrace',
              ),
              const SizedBox(height: 16),

              // Invalid token
              _TestButton(
                icon: Icons.error_outline,
                title: 'Invalid Token',
                subtitle:
                    'Simulates expired or wrong QR code\nShould show 404 error',
                color: Colors.red,
                token: 'invalid-token-xyz',
              ),

              const SizedBox(height: 32),

              Text(
                'Available test tokens:',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...TableSessionMock.validTestTokens.map(
                    (token) => Chip(label: Text(token)),
                  ),
                  Chip(
                    label: Text(TableSessionMock.invalidTestToken),
                    backgroundColor: theme.colorScheme.error.withValues(
                      alpha: 0.1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestButton extends ConsumerWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String token;

  const _TestButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.token,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => TableSessionScreen(token: token)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
