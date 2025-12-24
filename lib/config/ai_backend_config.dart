/// AI Backend Configuration
/// Defines available AI backends for the GenUI app
enum AiBackend {
  vertexAi,
  googleGenerativeAi,
  claudeA2ui,
}

/// Extension to provide display names for each backend
extension AiBackendExtension on AiBackend {
  String get displayName {
    switch (this) {
      case AiBackend.vertexAi:
        return 'Firebase Vertex AI';
      case AiBackend.googleGenerativeAi:
        return 'Google Generative AI';
      case AiBackend.claudeA2ui:
        return 'Claude (A2UI)';
    }
  }

  String get description {
    switch (this) {
      case AiBackend.vertexAi:
        return 'Firebase Vertex AI (Gemini) - Production ready';
      case AiBackend.googleGenerativeAi:
        return 'Google Generative AI - Direct API access';
      case AiBackend.claudeA2ui:
        return 'Claude via A2UI protocol server';
    }
  }
}

/// Configuration settings for each backend
class AiBackendSettings {
  // Vertex AI - uses Firebase configuration (no additional settings needed)

  // Google Generative AI settings
  static String? googleGenerativeAiApiKey;
  static String googleGenerativeAiModel = 'models/gemini-2.0-flash-exp';

  // Claude A2UI settings
  static String claudeA2uiServerUrl = 'http://localhost:8080';

  // Default backend (can be changed at runtime)
  static AiBackend defaultBackend = AiBackend.vertexAi;

  /// Load settings from environment variables or config file
  static void loadFromEnvironment() {
    // Load Google Generative AI API key from environment
    googleGenerativeAiApiKey = const String.fromEnvironment(
      'GEMINI_API_KEY',
      defaultValue: '',
    );

    // Load Claude A2UI server URL from environment
    final envServerUrl = const String.fromEnvironment(
      'CLAUDE_A2UI_SERVER_URL',
      defaultValue: '',
    );
    if (envServerUrl.isNotEmpty) {
      claudeA2uiServerUrl = envServerUrl;
    }

    // Load default backend from environment
    final envBackend = const String.fromEnvironment(
      'DEFAULT_AI_BACKEND',
      defaultValue: 'vertexAi',
    );
    defaultBackend = _parseBackend(envBackend);
  }

  static AiBackend _parseBackend(String value) {
    switch (value.toLowerCase()) {
      case 'vertex':
      case 'vertexai':
      case 'firebase':
        return AiBackend.vertexAi;
      case 'google':
      case 'googleai':
      case 'generativeai':
        return AiBackend.googleGenerativeAi;
      case 'claude':
      case 'a2ui':
        return AiBackend.claudeA2ui;
      default:
        return AiBackend.vertexAi;
    }
  }
}
