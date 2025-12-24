import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/ai_backend_config.dart';
import 'config/content_generator_factory.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GenUiConversation _genUiConversation;
  late A2uiMessageProcessor _a2uiMessageProcessor;
  final List<String> _surfaceIds = [];
  final TextEditingController _textController = TextEditingController();
  bool _isInitialized = false;
  AiBackend _currentBackend = AiBackendSettings.defaultBackend;
  String? _backendError;

  @override
  void initState() {
    super.initState();
    _loadSavedBackend();
  }

  Future<void> _loadSavedBackend() async {
    final prefs = await SharedPreferences.getInstance();
    final savedBackend = prefs.getString('ai_backend');
    if (savedBackend != null) {
      final backend = AiBackend.values.firstWhere(
        (b) => b.name == savedBackend,
        orElse: () => AiBackendSettings.defaultBackend,
      );
      setState(() {
        _currentBackend = backend;
      });
    }
    _initializeGenUi(_currentBackend);
  }

  Future<void> _initializeGenUi(AiBackend backend) async {
    setState(() {
      _isInitialized = false;
      _backendError = null;
      _surfaceIds.clear();
    });

    try {
      // Validate backend configuration
      final validationError = ContentGeneratorFactory.validateBackend(backend);
      if (validationError != null) {
        setState(() {
          _backendError = validationError;
          _isInitialized = true;
        });
        return;
      }

      // Create the A2UI message processor with core catalog
      _a2uiMessageProcessor = A2uiMessageProcessor(
        catalogs: [CoreCatalogItems.asCatalog()],
      );

      // Create the content generator using the factory
      final contentGenerator = ContentGeneratorFactory.create(backend);

      // Create the GenUI conversation
      _genUiConversation = GenUiConversation(
        a2uiMessageProcessor: _a2uiMessageProcessor,
        contentGenerator: contentGenerator,
        onSurfaceAdded: _onSurfaceAdded,
        onSurfaceDeleted: _onSurfaceDeleted,
      );

      setState(() {
        _isInitialized = true;
        _currentBackend = backend;
      });

      // Save the selected backend
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('ai_backend', backend.name);

      // Send an initial welcome message
      _genUiConversation.sendRequest(
        UserMessage.text(
          'Welcome the user to the Cultural Trip Planner and show them a beautiful interface with popular destinations to explore (Paris, Rome, Carthage, Budapest, Tokyo, Cairo). Use cards or buttons they can interact with.',
        ),
      );
    } catch (e) {
      debugPrint('Error initializing GenUI: $e');
      setState(() {
        _backendError = 'Failed to initialize ${backend.displayName}: $e';
        _isInitialized = true;
      });
    }
  }

  Future<void> _switchBackend(AiBackend newBackend) async {
    if (newBackend == _currentBackend) return;
    await _initializeGenUi(newBackend);
  }

  void _onSurfaceAdded(SurfaceAdded update) {
    setState(() {
      // Clear previous surfaces to show only the latest one
      // This prevents duplication and keeps the UI clean
      _surfaceIds.clear();
      _surfaceIds.add(update.surfaceId);
    });
  }

  void _onSurfaceDeleted(SurfaceRemoved update) {
    setState(() {
      _surfaceIds.remove(update.surfaceId);
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    _textController.clear();
    _genUiConversation.sendRequest(UserMessage.text(text));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showBackendSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select AI Backend',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...AiBackend.values.map((backend) {
              final validationError =
                  ContentGeneratorFactory.validateBackend(backend);
              final isAvailable = validationError == null;
              final isSelected = backend == _currentBackend;

              return ListTile(
                leading: Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                title: Text(backend.displayName),
                subtitle: Text(
                  isAvailable ? backend.description : validationError,
                  style: TextStyle(
                    color: isAvailable
                        ? null
                        : Theme.of(context).colorScheme.error,
                  ),
                ),
                enabled: isAvailable,
                selected: isSelected,
                onTap: isAvailable
                    ? () {
                        Navigator.pop(context);
                        _switchBackend(backend);
                      }
                    : null,
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cultural Trip Planner'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            tooltip: 'AI Backend: ${_currentBackend.displayName}',
            onSelected: (value) {
              if (value == 'switch_backend') {
                _showBackendSelector();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'switch_backend',
                child: Row(
                  children: [
                    const Icon(Icons.swap_horiz),
                    const SizedBox(width: 8),
                    Text('Switch Backend\n(Current: ${_currentBackend.displayName})'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: !_isInitialized
          ? const Center(child: CircularProgressIndicator())
          : _backendError != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Backend Error',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _backendError!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _showBackendSelector,
                          icon: const Icon(Icons.swap_horiz),
                          label: const Text('Switch Backend'),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    // Backend indicator banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withValues(alpha: 0.3),
                      child: Row(
                        children: [
                          Icon(
                            Icons.smart_toy,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Using: ${_currentBackend.displayName}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Display AI-generated surfaces
                    Expanded(
                      child: _surfaceIds.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: GenUiSurface(
                                host: _genUiConversation.host,
                                surfaceId: _surfaceIds.first,
                              ),
                            ),
                    ),
                    // Input area
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              decoration: InputDecoration(
                                hintText: 'Ask about any destination...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              onSubmitted: _sendMessage,
                            ),
                          ),
                          const SizedBox(width: 8),
                          FloatingActionButton(
                            onPressed: () => _sendMessage(_textController.text),
                            child: const Icon(Icons.send),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
