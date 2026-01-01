import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paygoo/models/app_config.dart';
import 'package:paygoo/models/locale_config.dart';
import 'package:paygoo/models/ui_strings.dart';
import 'package:paygoo/services/app_config_service.dart';
import 'package:paygoo/services/local_cache_service.dart';

/// State for locale management
class LocaleState {
  const LocaleState({
    required this.currentLocale,
    required this.config,
    this.isLoading = false,
    this.error,
  });

  /// Current active locale
  final AppLocale currentLocale;

  /// Current app configuration (includes UI strings)
  final AppConfig config;

  /// Whether a locale change is in progress
  final bool isLoading;

  /// Error message if locale change failed
  final String? error;

  /// Quick access to UI strings
  UiStrings get strings => config.strings;

  /// Quick access to features
  AppFeatures get features => config.features;

  /// Supported locales for the current restaurant
  List<AppLocale> get supportedLocales => config.supportedLocales;

  LocaleState copyWith({
    AppLocale? currentLocale,
    AppConfig? config,
    bool? isLoading,
    String? error,
  }) {
    return LocaleState(
      currentLocale: currentLocale ?? this.currentLocale,
      config: config ?? this.config,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for managing locale state
class LocaleNotifier extends AsyncNotifier<LocaleState> {
  late AppConfigService _configService;
  late LocalCacheService _cacheService;

  @override
  Future<LocaleState> build() async {
    // Initialize services
    _cacheService = await LocalCacheService.getInstance();
    _configService = AppConfigService(cacheService: _cacheService);

    // Get saved locale or use system locale
    final savedLocaleCode = _cacheService.getString(
      LocalCacheService.keyLocale,
    );
    final initialLocale = savedLocaleCode != null
        ? AppLocale.fromCode(savedLocaleCode)
        : _getSystemLocale();

    // Fetch config for initial locale
    final config = await _configService.getConfig(initialLocale);

    return LocaleState(currentLocale: initialLocale, config: config);
  }

  /// Change the current locale
  Future<void> setLocale(AppLocale locale) async {
    final currentState = switch (state) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (currentState == null) return;

    // Skip if already on this locale
    if (currentState.currentLocale == locale) return;

    // Set loading state
    state = AsyncValue.data(currentState.copyWith(isLoading: true));

    try {
      // Get config for new locale
      final config = await _configService.getConfig(locale);

      // Save preference
      await _cacheService.saveString(LocalCacheService.keyLocale, locale.code);

      // Update state
      state = AsyncValue.data(
        LocaleState(currentLocale: locale, config: config),
      );
    } catch (e) {
      // Revert to previous state with error
      state = AsyncValue.data(
        currentState.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  /// Refresh config for current locale (force network fetch)
  Future<void> refreshConfig() async {
    final currentState = switch (state) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (currentState == null) return;

    state = AsyncValue.data(currentState.copyWith(isLoading: true));

    try {
      await _configService.clearCache();
      final config = await _configService.getConfig(currentState.currentLocale);

      state = AsyncValue.data(
        LocaleState(currentLocale: currentState.currentLocale, config: config),
      );
    } catch (e) {
      state = AsyncValue.data(
        currentState.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  /// Preload locales for faster switching
  Future<void> preloadLocales(List<AppLocale> locales) async {
    await _configService.preloadLocales(locales);
  }

  /// Get system locale
  AppLocale _getSystemLocale() {
    final systemLocale = ui.PlatformDispatcher.instance.locale;
    return AppLocale.fromSystemLocale(systemLocale.languageCode);
  }
}

/// Provider for locale state
final localeProvider = AsyncNotifierProvider<LocaleNotifier, LocaleState>(
  LocaleNotifier.new,
);

/// Convenience provider for just the UI strings
final uiStringsProvider = Provider<UiStrings>((ref) {
  final localeState = ref.watch(localeProvider);
  return switch (localeState) {
    AsyncData(:final value) => value.strings,
    _ => UiStrings.fallback,
  };
});

/// Convenience provider for current locale
final currentLocaleProvider = Provider<AppLocale>((ref) {
  final localeState = ref.watch(localeProvider);
  return switch (localeState) {
    AsyncData(:final value) => value.currentLocale,
    _ => AppLocale.en,
  };
});
