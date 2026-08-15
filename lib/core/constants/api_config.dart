class ApiConfig {
  static const primaryBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.mangadex.org',
  );

  static const fallbackBaseUrl = String.fromEnvironment(
    'API_FALLBACK_URL',
    defaultValue: '',
  );
}
