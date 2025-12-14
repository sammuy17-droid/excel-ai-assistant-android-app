class AppConfig {
  static const String backendBaseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'https://YOUR_BACKEND_DOMAIN_HERE',
  );
}
