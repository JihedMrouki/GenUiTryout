import 'package:genui/genui.dart';
import 'package:genui_firebase_ai/genui_firebase_ai.dart';
import 'package:genui_google_generative_ai/genui_google_generative_ai.dart';
import 'package:genui_a2ui/genui_a2ui.dart';
import 'ai_backend_config.dart';

/// Factory class to create ContentGenerator instances based on selected backend
class ContentGeneratorFactory {
  /// System instruction shared across all backends
  static const String systemInstruction = '''
You are a helpful cultural trip planning assistant. Help users plan amazing cultural trips to destinations like Paris, Rome, Carthage, Budapest, and other cultural destinations around the world.

When users ask about a destination:
1. Create engaging, beautiful interfaces showing cultural highlights
2. Include information about museums, historical sites, local cuisine, and cultural events
3. Suggest itineraries with must-see attractions
4. Provide practical tips about the best time to visit, local customs, and transportation
5. Use cards, lists, and organized layouts to present information clearly
6. Include interesting facts and cultural insights

IMPORTANT LAYOUT RULES:
- For the welcome screen: Use a GRID layout (GridView) with 2 columns to show destination cards
- For detail pages: Use VERTICAL layouts (Column) with proper spacing, NOT horizontal rows
- NEVER create horizontal rows that are too wide - always use Column for stacking content vertically
- Keep content within reasonable widths - use vertical scrolling, not horizontal
- Use Wrap widgets if you need to show multiple items that might overflow

IMPORTANT: Do NOT use external image URLs (like Wikipedia, Wikimedia, or other image hosting services). Instead:
- Use icons and emojis to represent destinations and attractions (🗼 for Eiffel Tower, 🏛️ for museums, 🍝 for food, etc.)
- Use colored containers and cards for visual appeal
- Focus on text-based, well-organized information
- Use the available Flutter widgets creatively without relying on network images

Make the interfaces visually appealing and informative using Flutter's built-in widgets, icons, and styling. Be enthusiastic about cultural exploration!
''';

  /// Creates a ContentGenerator based on the selected backend
  static ContentGenerator create(AiBackend backend) {
    final catalog = CoreCatalogItems.asCatalog();

    switch (backend) {
      case AiBackend.vertexAi:
        return _createFirebaseVertexAi(catalog);

      case AiBackend.googleGenerativeAi:
        return _createGoogleGenerativeAi(catalog);

      case AiBackend.claudeA2ui:
        return _createClaudeA2ui(catalog);
    }
  }

  /// Creates Firebase Vertex AI content generator
  static ContentGenerator _createFirebaseVertexAi(Catalog catalog) {
    return FirebaseAiContentGenerator(
      catalog: catalog,
      systemInstruction: systemInstruction,
    );
  }

  /// Creates Google Generative AI content generator
  static ContentGenerator _createGoogleGenerativeAi(Catalog catalog) {
    final apiKey = AiBackendSettings.googleGenerativeAiApiKey;

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'Google Generative AI API key not configured. '
        'Please set GEMINI_API_KEY environment variable or update AiBackendSettings.',
      );
    }

    return GoogleGenerativeAiContentGenerator(
      catalog: catalog,
      systemInstruction: systemInstruction,
      modelName: AiBackendSettings.googleGenerativeAiModel,
      apiKey: apiKey,
    );
  }

  /// Creates Claude A2UI content generator
  static ContentGenerator _createClaudeA2ui(Catalog catalog) {
    final serverUrl = AiBackendSettings.claudeA2uiServerUrl;

    if (serverUrl.isEmpty) {
      throw Exception(
        'Claude A2UI server URL not configured. '
        'Please set CLAUDE_A2UI_SERVER_URL environment variable or update AiBackendSettings.',
      );
    }

    return A2uiContentGenerator(
      serverUrl: Uri.parse(serverUrl),
    );
  }

  /// Validates that the selected backend can be initialized
  static String? validateBackend(AiBackend backend) {
    try {
      switch (backend) {
        case AiBackend.vertexAi:
          // Firebase is initialized in main.dart, always available
          return null;

        case AiBackend.googleGenerativeAi:
          final apiKey = AiBackendSettings.googleGenerativeAiApiKey;
          if (apiKey == null || apiKey.isEmpty) {
            return 'Missing API key. Please configure GEMINI_API_KEY.';
          }
          return null;

        case AiBackend.claudeA2ui:
          final serverUrl = AiBackendSettings.claudeA2uiServerUrl;
          if (serverUrl.isEmpty) {
            return 'Missing server URL. Please configure CLAUDE_A2UI_SERVER_URL.';
          }
          return null;
      }
    } catch (e) {
      return 'Configuration error: $e';
    }
  }
}
