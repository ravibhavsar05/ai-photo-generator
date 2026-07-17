class ApiConfig {
  // Read key from environment variable (injected via --dart-define or --dart-define-from-file)
  static String get geminiApiKey {
    const apiKey = String.fromEnvironment('GEMINI_API_KEY');
    return apiKey;
  }

  // Check if we are using the public demo key (if injected via .env)
  static bool get isUsingFallbackKey {
    return geminiApiKey == 'AIzaSyA8suN7qhWeBKB0tSqpC9fFOOxtvJ_1d2k';
  }

  static String get securityWarning {
    if (geminiApiKey.isEmpty) {
      return '❌ No Gemini API key provided. Add .env and run with --dart-define-from-file=.env';
    }
    return isUsingFallbackKey
        ? '⚠️ Using public demo API key from .env. Consider using your own key.'
        : '✓ Using secure environment API key';
  }
}
