import 'package:paygoo/models/locale_config.dart';
import 'package:paygoo/models/ui_strings.dart';

/// App configuration received from backend
/// Contains UI strings, feature flags, and restaurant-specific settings
class AppConfig {
  const AppConfig({
    required this.locale,
    required this.strings,
    required this.fetchedAt,
    this.restaurantId,
    this.restaurantName,
    this.supportedLocales = const [AppLocale.en, AppLocale.ro],
    this.features = const AppFeatures(),
  });

  /// Current locale for this config
  final AppLocale locale;

  /// UI strings in the current locale
  final UiStrings strings;

  /// When this config was fetched (for cache invalidation)
  final DateTime fetchedAt;

  /// Restaurant identifier (for multi-tenant support)
  final String? restaurantId;

  /// Restaurant display name
  final String? restaurantName;

  /// Locales supported by this restaurant
  final List<AppLocale> supportedLocales;

  /// Feature flags
  final AppFeatures features;

  /// Cache TTL - config is considered stale after this duration
  static const cacheTtl = Duration(hours: 24);

  /// Check if cache is still valid
  bool get isCacheValid =>
      DateTime.now().difference(fetchedAt) < cacheTtl;

  /// Create from JSON (backend response)
  factory AppConfig.fromJson(Map<String, dynamic> json, AppLocale locale) {
    final supportedLocaleCodes = json['supported_locales'] as List<dynamic>?;
    
    return AppConfig(
      locale: locale,
      strings: UiStrings.fromJson(
        json['strings'] as Map<String, dynamic>? ?? {},
      ),
      fetchedAt: DateTime.now(),
      restaurantId: json['restaurant_id'] as String?,
      restaurantName: json['restaurant_name'] as String?,
      supportedLocales: supportedLocaleCodes
          ?.map((code) => AppLocale.fromCode(code as String))
          .toList() ??
          [AppLocale.en, AppLocale.ro],
      features: AppFeatures.fromJson(
        json['features'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  /// Convert to JSON (for caching)
  Map<String, dynamic> toJson() {
    return {
      'locale': locale.code,
      'strings': strings.toJson(),
      'fetched_at': fetchedAt.toIso8601String(),
      'restaurant_id': restaurantId,
      'restaurant_name': restaurantName,
      'supported_locales': supportedLocales.map((l) => l.code).toList(),
      'features': features.toJson(),
    };
  }

  /// Create from cached JSON
  factory AppConfig.fromCachedJson(Map<String, dynamic> json) {
    return AppConfig(
      locale: AppLocale.fromCode(json['locale'] as String? ?? 'en'),
      strings: UiStrings.fromJson(
        json['strings'] as Map<String, dynamic>? ?? {},
      ),
      fetchedAt: DateTime.parse(
        json['fetched_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
      restaurantId: json['restaurant_id'] as String?,
      restaurantName: json['restaurant_name'] as String?,
      supportedLocales: (json['supported_locales'] as List<dynamic>?)
          ?.map((code) => AppLocale.fromCode(code as String))
          .toList() ??
          [AppLocale.en, AppLocale.ro],
      features: AppFeatures.fromJson(
        json['features'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  /// Default fallback config
  static AppConfig fallback(AppLocale locale) => AppConfig(
    locale: locale,
    strings: UiStrings.fallback,
    fetchedAt: DateTime.now(),
  );
}

/// Feature flags for the app
class AppFeatures {
  const AppFeatures({
    this.tipsEnabled = true,
    this.splitBillEnabled = false,
    this.reviewsEnabled = true,
  });

  final bool tipsEnabled;
  final bool splitBillEnabled;
  final bool reviewsEnabled;

  factory AppFeatures.fromJson(Map<String, dynamic> json) {
    return AppFeatures(
      tipsEnabled: json['tips_enabled'] as bool? ?? true,
      splitBillEnabled: json['split_bill_enabled'] as bool? ?? false,
      reviewsEnabled: json['reviews_enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tips_enabled': tipsEnabled,
      'split_bill_enabled': splitBillEnabled,
      'reviews_enabled': reviewsEnabled,
    };
  }
}

