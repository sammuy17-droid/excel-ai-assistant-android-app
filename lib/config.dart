class AppConfig {
  static const String backendBaseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'https://excel-ai-assistant-backend-app.onrender.com',
  );
}
