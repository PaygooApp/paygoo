import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paygoo/models/locale_config.dart';
import 'package:paygoo/models/ui_strings.dart';
import 'package:paygoo/providers/locale_provider.dart';

/// Extension for easy access to translations in widgets
/// 
/// Usage:
/// ```dart
/// // In a ConsumerWidget or ConsumerStatefulWidget:
/// Text(context.tr(ref).payYourBill)
/// 
/// // Or use the ref directly:
/// Text(ref.tr.payYourBill)
/// ```
extension TranslationsContext on BuildContext {
  /// Get UI strings using ref
  /// Usage: context.tr(ref).payYourBill
  UiStrings tr(WidgetRef ref) {
    return ref.watch(uiStringsProvider);
  }
}

/// Extension for direct access from WidgetRef
/// 
/// Usage in ConsumerWidget:
/// ```dart
/// Text(ref.tr.payYourBill)
/// Text(ref.tr.selectAll)
/// ```
extension TranslationsRef on WidgetRef {
  /// Get UI strings directly from ref
  UiStrings get tr => watch(uiStringsProvider);

  /// Get current locale
  AppLocale get currentLocale => watch(currentLocaleProvider);

  /// Change locale
  void setLocale(AppLocale locale) {
    read(localeProvider.notifier).setLocale(locale);
  }
}

/// Extension for changing locale with simple API
extension LocaleActions on WidgetRef {
  /// Switch to a specific locale
  Future<void> switchLocale(AppLocale locale) async {
    await read(localeProvider.notifier).setLocale(locale);
  }

  /// Refresh current config from network
  Future<void> refreshTranslations() async {
    await read(localeProvider.notifier).refreshConfig();
  }

  /// Preload locales for faster switching
  Future<void> preloadLocales(List<AppLocale> locales) async {
    await read(localeProvider.notifier).preloadLocales(locales);
  }
}

