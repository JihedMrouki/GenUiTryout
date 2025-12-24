# Setup Instructions - Multi-Backend GenUI App

## ✅ Implementation Complete!

Your GenUI app now supports **3 AI backends** that you can switch between at runtime!

---

## 🎯 Available Backends

1. **Firebase Vertex AI** (Already working!) ✅
2. **Google Generative AI** (Just needs API key) 🔑
3. **Claude via A2UI** (Custom server provided) 🔧

---

## 🚀 Quick Start

### Option 1: Run with Vertex AI (Default - Works Immediately!)

```bash
flutter pub get
flutter run
```

That's it! The app will use Firebase Vertex AI and work out of the box.

---

### Option 2: Run with Google Generative AI

**Step 1: Get API Key**
- Visit: https://aistudio.google.com/apikey
- Sign in with your Google account
- Click "Create API key"
- Copy your API key

**Step 2: Run the App**
```bash
flutter run --dart-define=GEMINI_API_KEY=your_api_key_here
```

**Step 3: Switch Backend in App**
1. Tap the settings icon (⚙️) in the top-right corner
2. Select "Switch Backend"
3. Choose "Google Generative AI"
4. Done! The app reinitializes instantly

---

### Option 3: Run with Claude (A2UI)

**Step 1: Set Up the A2UI Server**

Navigate to the server directory:
```bash
cd a2ui_server_example
```

Install dependencies:
```bash
npm install
```

Set your Claude API key:

**Windows (PowerShell):**
```powershell
$env:ANTHROPIC_API_KEY="your_claude_api_key_here"
```

**macOS/Linux:**
```bash
export ANTHROPIC_API_KEY="your_claude_api_key_here"
```

Get your API key from: https://console.anthropic.com/settings/keys

Start the server:
```bash
npm start
```

You should see:
```
A2UI Server running on http://localhost:8080
```

**Step 2: Run the Flutter App**

In a new terminal, navigate back to the project root:
```bash
cd ..
flutter run --dart-define=CLAUDE_A2UI_SERVER_URL=http://localhost:8080
```

**Step 3: Switch Backend in App**
1. Tap the settings icon (⚙️) in the top-right corner
2. Select "Switch Backend"
3. Choose "Claude (A2UI)"
4. Done!

---

## 🔄 Switching Backends at Runtime

Once the app is running, you can switch between backends anytime:

1. **Tap the settings icon** (⚙️) in the app bar
2. **Select "Switch Backend"**
3. **Choose your desired backend:**
   - ✅ Green checkmark = Currently active
   - ○ Available = Ready to use
   - ○ Red text = Needs configuration

4. **Tap to select** - The app reinitializes instantly!

**Your selection is saved** and persists across app restarts.

---

## 🎨 UI Features

### Backend Indicator
At the top of the screen, you'll see which backend is active:
```
🤖 Using: Firebase Vertex AI
```

### Settings Menu
- **Tap ⚙️** to access backend switcher
- **Hover** to see current backend in tooltip

### Error Handling
If a backend isn't configured, you'll see a friendly error message with a button to switch backends.

---

## 📁 Project Structure

### New Configuration Files
```
lib/
├── config/
│   ├── ai_backend_config.dart          # Backend enum & settings
│   └── content_generator_factory.dart   # Factory for creating backends
└── my_home_page.dart                    # Updated with switching UI

a2ui_server_example/                     # Claude server example
├── server.js                            # Node.js A2UI server
├── package.json                         # npm dependencies
└── README.md                            # Server setup guide
```

### Documentation Files
```
BACKEND_SETUP.md              # Comprehensive setup guide
QUICK_START.md                # Quick reference
HOW_TO_SWITCH_BACKENDS.md     # Visual switching guide
IMPLEMENTATION_SUMMARY.md     # Technical overview
SETUP_INSTRUCTIONS.md         # This file
```

---

## 🔧 Configuration Methods

### Method 1: Environment Variables (Recommended)

**Set at launch time:**
```bash
# Use Google Generative AI
flutter run \
  --dart-define=DEFAULT_AI_BACKEND=googleGenerativeAi \
  --dart-define=GEMINI_API_KEY=your_key

# Use Claude
flutter run \
  --dart-define=DEFAULT_AI_BACKEND=claudeA2ui \
  --dart-define=CLAUDE_A2UI_SERVER_URL=http://localhost:8080

# Use Vertex AI (default)
flutter run
```

### Method 2: Code Configuration

Edit `lib/config/ai_backend_config.dart`:

```dart
class AiBackendSettings {
  // Set API keys
  static String? googleGenerativeAiApiKey = 'your_api_key_here';
  static String claudeA2uiServerUrl = 'http://localhost:8080';

  // Set default backend
  static AiBackend defaultBackend = AiBackend.vertexAi;
}
```

Change `defaultBackend` to:
- `AiBackend.vertexAi` - Firebase Vertex AI
- `AiBackend.googleGenerativeAi` - Google Generative AI
- `AiBackend.claudeA2ui` - Claude via A2UI

### Method 3: Runtime UI Switching

Just use the app's settings menu - your choice is saved automatically!

---

## 🐛 Troubleshooting

### "Missing API key" Error

**For Google Generative AI:**
```bash
flutter run --dart-define=GEMINI_API_KEY=your_key_here
```

Or edit `lib/config/ai_backend_config.dart` and set:
```dart
static String? googleGenerativeAiApiKey = 'your_api_key_here';
```

### "Missing server URL" Error

**For Claude A2UI:**

1. Make sure the server is running:
```bash
cd a2ui_server_example
npm start
```

2. Test the server:
```bash
curl http://localhost:8080/health
```

3. Run the app with server URL:
```bash
flutter run --dart-define=CLAUDE_A2UI_SERVER_URL=http://localhost:8080
```

### App Stuck on Loading

1. Check the Flutter console for error messages
2. Tap the settings icon (⚙️) to see if there's a backend error
3. Try switching to a different backend
4. Verify your internet connection

### Backend Shows as Unavailable

- Check that all required API keys are set
- For A2UI: Ensure the server is running and accessible
- Check the Flutter console for specific error messages

---

## 📊 Backend Comparison

| Feature | Vertex AI | Google Gen AI | Claude (A2UI) |
|---------|-----------|---------------|---------------|
| **Setup** | ✅ Done | 🔑 API key | 🔧 Server + API |
| **Production** | ✅ Yes | ⚠️ Limited | ✅ Yes (with server) |
| **Latency** | Low | Low | Medium |
| **Model** | Gemini | Gemini | Claude |
| **Best For** | Production | Quick testing | Custom AI needs |

---

## 💡 Tips

1. **Start with Vertex AI** - It's already configured and reliable
2. **Use Google Gen AI for testing** - Easy setup, just needs an API key
3. **Use Claude for advanced needs** - When you need Claude's specific capabilities
4. **Switch anytime** - No restart required, just tap ⚙️
5. **Your choice persists** - Selection is saved automatically

---

## 🔒 Security Best Practices

### ⚠️ Important: Never Commit API Keys!

The following files contain sensitive data and are now in `.gitignore`:
- `.env` - Environment variables
- `lib/firebase_options.dart` - Firebase configuration (API keys, project IDs)
- `a2ui_server_example/.env` - Server API keys

**Note:** If you're setting up this project for the first time or cloning it, you'll need to configure Firebase:
- See **[FIREBASE_SETUP.md](FIREBASE_SETUP.md)** for detailed Firebase configuration instructions
- Use the template: `lib/firebase_options.dart.template`
- Or run: `flutterfire configure`

### Safe Configuration Methods:

**1. Use Environment Variables (Best for Production)**
```bash
flutter run --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY
```

**2. Use .env Files (Local Development)**
- Copy `.env.example` to `.env`
- Fill in your API keys
- Never commit `.env` to git (already in .gitignore)

**3. For Production Apps:**
- Use Firebase Remote Config
- Use secure key vaults (AWS Secrets Manager, Google Secret Manager)
- Fetch keys from your backend at runtime

---

## 📚 Additional Resources

- **GenUI Documentation:** https://docs.flutter.dev/ai/genui
- **GenUI GitHub:** https://github.com/flutter/genui
- **A2UI Specification:** https://github.com/google/A2UI
- **Google AI Studio:** https://aistudio.google.com
- **Anthropic Console:** https://console.anthropic.com

---

## 📖 Documentation Files

For more detailed information, check out:

- **[QUICK_START.md](QUICK_START.md)** - TL;DR guide to get started fast
- **[BACKEND_SETUP.md](BACKEND_SETUP.md)** - Comprehensive setup for all backends
- **[HOW_TO_SWITCH_BACKENDS.md](HOW_TO_SWITCH_BACKENDS.md)** - Visual guide to switching
- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - Technical details
- **[a2ui_server_example/README.md](a2ui_server_example/README.md)** - Server setup guide

---

## 🎉 You're All Set!

Run your app and enjoy switching between different AI backends:

```bash
flutter run
```

Happy building! 🚀

---

## 🆘 Need Help?

If you run into issues:
1. Check the troubleshooting section above
2. Review the Flutter console for error messages
3. Consult the detailed setup guides in the documentation files
4. Ensure all API keys and configurations are properly set

---

## 📝 Quick Command Reference

```bash
# Install dependencies
flutter pub get

# Run with Vertex AI (default)
flutter run

# Run with Google Generative AI
flutter run --dart-define=GEMINI_API_KEY=your_key

# Run with Claude (requires server)
cd a2ui_server_example && npm start
# In another terminal:
flutter run --dart-define=CLAUDE_A2UI_SERVER_URL=http://localhost:8080

# Check server health
curl http://localhost:8080/health
```

---

Made with ❤️ for flexible AI backend integration
