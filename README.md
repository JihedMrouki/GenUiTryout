# GenUI Demo - Multi-Backend Cultural Trip Planner

A Flutter app demonstrating **GenUI** (Generated UI) with support for **multiple AI backends** that can be switched at runtime.

## ✨ Features

- 🎨 **AI-Generated UIs** - Dynamic interfaces created by AI based on user requests
- 🔄 **Multi-Backend Support** - Switch between 3 different AI backends at runtime:
  - Firebase Vertex AI (Gemini)
  - Google Generative AI (Gemini Direct API)
  - Claude via A2UI protocol
- 💾 **Persistent Preferences** - Your backend choice is saved automatically
- 🎯 **Cultural Trip Planning** - Get travel recommendations with beautiful AI-generated interfaces
- 🔐 **Secure Configuration** - Proper secrets management with .gitignore

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (3.10.4 or higher)
- Firebase account (for Vertex AI backend)
- Node.js (for Claude A2UI server, optional)

### Installation

1. **Clone the repository**
```bash
git clone <your-repo-url>
cd genui_demo
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Firebase** (Required)

Choose one option:

**Option A: Use FlutterFire CLI (Recommended)**
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

**Option B: Manual Setup**
```bash
cp lib/firebase_options.dart.template lib/firebase_options.dart
# Edit lib/firebase_options.dart with your Firebase project details
```

See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for detailed instructions.

4. **Run the app**
```bash
flutter run
```

## 🎯 Using Different Backends

### Firebase Vertex AI (Default)

Already configured! Just run:
```bash
flutter run
```

### Google Generative AI

Get API key from [Google AI Studio](https://aistudio.google.com/apikey), then:
```bash
flutter run --dart-define=GEMINI_API_KEY=your_api_key_here
```

Switch to it in the app: Tap ⚙️ → "Switch Backend" → "Google Generative AI"

### Claude (A2UI)

1. Start the A2UI server:
```bash
cd a2ui_server_example
npm install
export ANTHROPIC_API_KEY=your_claude_key
npm start
```

2. Run the app:
```bash
flutter run --dart-define=CLAUDE_A2UI_SERVER_URL=http://localhost:8080
```

Switch to it in the app: Tap ⚙️ → "Switch Backend" → "Claude (A2UI)"

## 📖 Documentation

Comprehensive guides are available:

- **[SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md)** - Complete setup guide with all backends
- **[QUICK_START.md](QUICK_START.md)** - TL;DR quick reference
- **[BACKEND_SETUP.md](BACKEND_SETUP.md)** - Detailed backend configuration
- **[HOW_TO_SWITCH_BACKENDS.md](HOW_TO_SWITCH_BACKENDS.md)** - Visual switching guide
- **[FIREBASE_SETUP.md](FIREBASE_SETUP.md)** - Firebase configuration help
- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - Technical architecture details
- **[a2ui_server_example/README.md](a2ui_server_example/README.md)** - A2UI server setup

## 🏗️ Project Structure

```
genui_demo/
├── lib/
│   ├── config/
│   │   ├── ai_backend_config.dart           # Backend enum & settings
│   │   └── content_generator_factory.dart   # Factory for creating backends
│   ├── firebase_options.dart                # Firebase config (gitignored)
│   ├── firebase_options.dart.template       # Template for Firebase config
│   ├── main.dart                            # App entry point
│   └── my_home_page.dart                    # Main UI with backend switching
├── a2ui_server_example/                     # Claude A2UI server
│   ├── server.js                            # Node.js server
│   ├── package.json                         # Dependencies
│   └── README.md                            # Server setup guide
├── SETUP_INSTRUCTIONS.md                    # Main setup guide
├── FIREBASE_SETUP.md                        # Firebase configuration
└── README.md                                # This file
```

## 🎨 How It Works

### GenUI Framework

GenUI is Google's framework for creating dynamic UIs with AI. Instead of hardcoding screens, you provide:
1. A **catalog** of available widgets
2. A **system instruction** to guide the AI
3. **User messages** describing what they want to see

The AI generates Flutter widgets based on your requests!

### Multi-Backend Architecture

```
MyHomePage (UI)
       ↓
ContentGeneratorFactory
       ↓
    ┌──────┴──────┬──────────┐
    ↓             ↓          ↓
Firebase      Google     Claude
Vertex AI     Gen AI     (A2UI)
```

Each backend implements the `ContentGenerator` interface, allowing seamless switching without changing the UI layer.

## 🔐 Security

**Important files in `.gitignore`:**
- `lib/firebase_options.dart` - Contains Firebase API keys
- `.env` - Environment variables
- `a2ui_server_example/.env` - Server secrets

**Never commit these files!** Use the provided templates instead.

See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for security best practices.

## 🛠️ Development

### Adding a New Backend

1. Add to `AiBackend` enum in `ai_backend_config.dart`
2. Implement `ContentGenerator` interface
3. Add factory method in `content_generator_factory.dart`
4. Update validation logic

See [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) for details.

### Running Tests

```bash
flutter test
```

### Building for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release
```

## 📊 Backend Comparison

| Backend | Setup | Latency | Best For |
|---------|-------|---------|----------|
| **Vertex AI** | Medium | Low | Production apps |
| **Google Gen AI** | Easy | Low | Quick testing |
| **Claude A2UI** | Advanced | Medium | Claude-specific needs |

## 🐛 Troubleshooting

### Common Issues

**"Firebase not initialized"**
- Run `flutterfire configure`
- Or copy `firebase_options.dart.template` and configure manually

**"Missing API key"**
- For Google Gen AI: Set `GEMINI_API_KEY`
- For Claude: Set `ANTHROPIC_API_KEY` and ensure server is running

**App stuck loading**
- Check Flutter console for errors
- Try switching backends via settings (⚙️)
- Verify internet connection

See [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md) for more troubleshooting.

## 📚 Resources

- **GenUI Documentation:** https://docs.flutter.dev/ai/genui
- **GenUI GitHub:** https://github.com/flutter/genui
- **A2UI Specification:** https://github.com/google/A2UI
- **Flutter:** https://flutter.dev
- **Firebase:** https://firebase.google.com

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with all backends
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- **Google** for GenUI framework and A2UI protocol
- **Anthropic** for Claude API
- **Firebase** for Vertex AI integration

## 📞 Support

For issues and questions:
1. Check the documentation files listed above
2. Review [SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md)
3. Open an issue on GitHub

---

Built with ❤️ using Flutter and GenUI

**Note:** This is a demo application showcasing GenUI capabilities with multiple AI backends. Configure your API keys and Firebase project before use.
