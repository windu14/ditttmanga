class ApiConfig {
  static const primaryBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.jikan.moe/v4',
  );

  static const fallbackBaseUrl = String.fromEnvironment(
    'API_FALLBACK_URL',
    defaultValue: '',
  );
}
