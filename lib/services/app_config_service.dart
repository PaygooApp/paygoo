import 'package:flutter/foundation.dart';
import 'package:paygoo/models/app_config.dart';
import 'package:paygoo/models/locale_config.dart';
import 'package:paygoo/models/ui_strings.dart';
import 'package:paygoo/services/local_cache_service.dart';

/// Service for fetching and caching app configuration
/// Handles both network requests and local caching
class AppConfigService {
  AppConfigService({required this.cacheService, this.baseUrl});

  final LocalCacheService cacheService;
  final String? baseUrl;

  /// In-memory cache for instant locale switching
  final Map<AppLocale, AppConfig> _memoryCache = {};

  /// Get config for a locale
  /// Priority: memory cache > local cache > network > fallback
  Future<AppConfig> getConfig(AppLocale locale) async {
    // 1. Check memory cache first (instant)
    if (_memoryCache.containsKey(locale)) {
      final cached = _memoryCache[locale]!;
      if (cached.isCacheValid) {
        debugPrint('AppConfigService: Using memory cache for ${locale.code}');
        return cached;
      }
    }

    // 2. Check local cache (SharedPreferences)
    final localCached = _getFromLocalCache(locale);
    if (localCached != null && localCached.isCacheValid) {
      debugPrint('AppConfigService: Using local cache for ${locale.code}');
      _memoryCache[locale] = localCached;
      return localCached;
    }

    // 3. Try to fetch from network
    try {
      final networkConfig = await _fetchFromNetwork(locale);
      if (networkConfig != null) {
        debugPrint('AppConfigService: Fetched from network for ${locale.code}');
        _memoryCache[locale] = networkConfig;
        await _saveToLocalCache(locale, networkConfig);
        return networkConfig;
      }
    } catch (e) {
      debugPrint('AppConfigService: Network fetch failed: $e');
    }

    // 4. Use stale cache if available
    if (localCached != null) {
      debugPrint('AppConfigService: Using stale cache for ${locale.code}');
      _memoryCache[locale] = localCached;
      return localCached;
    }

    // 5. Fallback to defaults
    debugPrint('AppConfigService: Using fallback for ${locale.code}');
    final fallback = AppConfig.fallback(locale);
    _memoryCache[locale] = fallback;
    return fallback;
  }

  /// Check if locale is already cached (for instant switching)
  bool isLocaleCached(AppLocale locale) {
    return _memoryCache.containsKey(locale);
  }

  /// Preload multiple locales in the background
  Future<void> preloadLocales(List<AppLocale> locales) async {
    await Future.wait(locales.map((locale) => getConfig(locale)));
  }

  /// Clear all caches (for logout/refresh)
  Future<void> clearCache() async {
    _memoryCache.clear();
    for (final locale in AppLocale.values) {
      await cacheService.remove(
        LocalCacheService.keyConfigForLocale(locale.code),
      );
    }
  }

  /// Fetch config from backend
  Future<AppConfig?> _fetchFromNetwork(AppLocale locale) async {
    // TODO: Implement actual HTTP request when backend is ready
    // Example:
    // final response = await http.get(
    //   Uri.parse('$baseUrl/api/config?lang=${locale.code}'),
    //   headers: {'Accept-Language': locale.code},
    // );
    // if (response.statusCode == 200) {
    //   final json = jsonDecode(response.body) as Map<String, dynamic>;
    //   return AppConfig.fromJson(json, locale);
    // }

    // For now, return mock data based on locale
    return _getMockConfig(locale);
  }

  /// Get from local cache
  AppConfig? _getFromLocalCache(AppLocale locale) {
    final json = cacheService.getJson(
      LocalCacheService.keyConfigForLocale(locale.code),
    );
    if (json == null) return null;
    return AppConfig.fromCachedJson(json);
  }

  /// Save to local cache
  Future<void> _saveToLocalCache(AppLocale locale, AppConfig config) async {
    await cacheService.saveJson(
      LocalCacheService.keyConfigForLocale(locale.code),
      config.toJson(),
    );
  }

  /// Mock config for development (remove when backend is ready)
  AppConfig? _getMockConfig(AppLocale locale) {
    return AppConfig(
      locale: locale,
      strings: _getMockStrings(locale),
      fetchedAt: DateTime.now(),
      restaurantId: 'demo_restaurant',
      restaurantName: 'Demo Restaurant',
      supportedLocales: [AppLocale.en, AppLocale.ro],
    );
  }

  /// Mock strings for development
  UiStrings _getMockStrings(AppLocale locale) {
    switch (locale) {
      case AppLocale.ro:
        return const UiStrings(
          payYourBill: 'Plătește Nota',
          selectAll: 'Selectează Tot',
          deselectAll: 'Deselectează Tot',
          paymentMethods: 'Metode de Plată',
          addTips: 'Adaugă bacșiș',
          optional: '(opțional)',
          serviceFee: 'Cost Serviciu',
          tipAmount: 'Suma Bacșiș',
          custom: 'Personalizat',
          swipeToPay: 'Glisează pentru a plăti',
          processing: 'Se procesează...',
          paymentSuccessful: 'Plată Reușită',
          paymentFailed: 'Plată Eșuată',
          thankYou: 'Mulțumim pentru plată!',
          tryAgain: 'Încearcă Din Nou',
          backToHome: 'Înapoi la Acasă',
          loading: 'Se încarcă...',
          error: 'A apărut o eroare',
          retry: 'Reîncearcă',
          cancel: 'Anulează',
          confirm: 'Confirmă',
          done: 'Gata',
        );
      case AppLocale.es:
        return const UiStrings(
          payYourBill: 'Paga Tu Cuenta',
          selectAll: 'Seleccionar Todo',
          deselectAll: 'Deseleccionar Todo',
          paymentMethods: 'Métodos de Pago',
          addTips: 'Añadir propina',
          optional: '(opcional)',
          serviceFee: 'Tarifa de Servicio',
          tipAmount: 'Cantidad de Propina',
          custom: 'Personalizado',
          swipeToPay: 'Desliza para pagar',
          processing: 'Procesando...',
          paymentSuccessful: 'Pago Exitoso',
          paymentFailed: 'Pago Fallido',
          thankYou: '¡Gracias por tu pago!',
          tryAgain: 'Intentar de Nuevo',
          backToHome: 'Volver al Inicio',
          loading: 'Cargando...',
          error: 'Ocurrió un error',
          retry: 'Reintentar',
          cancel: 'Cancelar',
          confirm: 'Confirmar',
          done: 'Hecho',
        );
      default:
        return const UiStrings(); // English defaults
    }
  }
}
