import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paygoo/models/locale_config.dart';
import 'package:paygoo/providers/locale_provider.dart';
import 'package:paygoo/tokens/token_primitive_mode1.dart';

/// A dropdown selector for changing the app locale
class LocaleSelector extends ConsumerWidget {
  const LocaleSelector({
    super.key,
    this.showFlag = true,
    this.showNativeName = true,
  });

  /// Whether to show country flag emoji
  final bool showFlag;

  /// Whether to show the native language name
  final bool showNativeName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeState = ref.watch(localeProvider);

    return localeState.when(
      loading: () => const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (error, _) => const Icon(Icons.error_outline),
      data: (state) => _buildSelector(context, ref, state),
    );
  }

  Widget _buildSelector(
    BuildContext context,
    WidgetRef ref,
    LocaleState state,
  ) {
    return PopupMenuButton<AppLocale>(
      initialValue: state.currentLocale,
      onSelected: (locale) {
        ref.read(localeProvider.notifier).setLocale(locale);
      },
      itemBuilder: (context) {
        return state.supportedLocales.map((locale) {
          final isSelected = locale == state.currentLocale;
          return PopupMenuItem<AppLocale>(
            value: locale,
            child: Row(
              children: [
                if (showFlag) ...[
                  Text(
                    _getFlagEmoji(locale),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  showNativeName ? locale.displayName : locale.code.toUpperCase(),
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? TokenPrimitiveMode1.primary600
                        : TokenPrimitiveMode1.gray900,
                  ),
                ),
                if (isSelected) ...[
                  const Spacer(),
                  Icon(
                    Icons.check,
                    size: 18,
                    color: TokenPrimitiveMode1.primary600,
                  ),
                ],
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: TokenPrimitiveMode1.gray200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showFlag) ...[
              Text(
                _getFlagEmoji(state.currentLocale),
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              state.currentLocale.code.toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: TokenPrimitiveMode1.gray700,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: TokenPrimitiveMode1.gray500,
            ),
          ],
        ),
      ),
    );
  }

  /// Get flag emoji for locale
  String _getFlagEmoji(AppLocale locale) {
    switch (locale) {
      case AppLocale.en:
        return '🇬🇧';
      case AppLocale.ro:
        return '🇷🇴';
      case AppLocale.es:
        return '🇪🇸';
      case AppLocale.de:
        return '🇩🇪';
      case AppLocale.fr:
        return '🇫🇷';
      case AppLocale.it:
        return '🇮🇹';
    }
  }
}

