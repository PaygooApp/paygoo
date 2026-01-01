/// Supported locales in the app
enum AppLocale {
  en('en', 'English'),
  ro('ro', 'Română'),
  es('es', 'Español'),
  de('de', 'Deutsch'),
  fr('fr', 'Français'),
  it('it', 'Italiano');

  const AppLocale(this.code, this.displayName);

  /// ISO 639-1 language code
  final String code;

  /// Human-readable name in the native language
  final String displayName;

  /// Get AppLocale from language code
  static AppLocale fromCode(String code) {
    return AppLocale.values.firstWhere(
      (locale) => locale.code == code,
      orElse: () => AppLocale.en,
    );
  }

  /// Get AppLocale from system locale
  static AppLocale fromSystemLocale(String? systemLocaleCode) {
    if (systemLocaleCode == null) return AppLocale.en;
    
    // Handle codes like 'en_US' or 'en-US'
    final code = systemLocaleCode.split(RegExp(r'[_-]')).first.toLowerCase();
    return fromCode(code);
  }
}

