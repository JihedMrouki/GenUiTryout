# How to Switch Between AI Backends

## 🎯 Visual Guide

### Method 1: Using the UI (Recommended)

#### Step 1: Open Settings Menu
```
┌──────────────────────────────────┐
│  Cultural Trip Planner       ⚙️ │  ← Tap this settings icon
└──────────────────────────────────┘
```

#### Step 2: Select "Switch Backend"
```
┌─────────────────────────────────┐
│  ⇄  Switch Backend              │  ← Tap this option
│     (Current: Firebase Vertex)  │
└─────────────────────────────────┘
```

#### Step 3: Choose Your Backend
```
┌─────────────────────────────────────────────┐
│  Select AI Backend                          │
│                                             │
│  ✅ Firebase Vertex AI                      │  ← Currently selected
│     Firebase Vertex AI - Production ready   │
│                                             │
│  ○  Google Generative AI                    │  ← Available
│     Google Generative AI - Direct API       │
│                                             │
│  ○  Claude (A2UI)                           │  ← Needs setup
│     Missing server URL...                   │  (shows error in red)
└─────────────────────────────────────────────┘
```

#### Step 4: App Reinitializes
```
Loading...  ← Brief loading screen

Then shows:
┌──────────────────────────────────┐
│  Using: Google Generative AI     │  ← New backend indicator
└──────────────────────────────────┘
```

---

## 🚀 Method 2: Using Environment Variables

### Set Backend at Launch

```bash
# Use Google Generative AI
flutter run --dart-define=DEFAULT_AI_BACKEND=googleGenerativeAi --dart-define=GEMINI_API_KEY=your_key

# Use Claude
flutter run --dart-define=DEFAULT_AI_BACKEND=claudeA2ui --dart-define=CLAUDE_A2UI_SERVER_URL=http://localhost:8080

# Use Vertex AI (default)
flutter run
```

---

## 🔧 Method 3: Edit Configuration File

### For Permanent Changes

Edit `lib/config/ai_backend_config.dart`:

```dart
class AiBackendSettings {
  // Set your API keys
  static String? googleGenerativeAiApiKey = 'your_api_key_here';
  static String claudeA2uiServerUrl = 'http://localhost:8080';

  // Set default backend
  static AiBackend defaultBackend = AiBackend.googleGenerativeAi;
  //                                             ↑
  //                           Change this to your preferred backend
}
```

Options for `defaultBackend`:
- `AiBackend.vertexAi` - Firebase Vertex AI
- `AiBackend.googleGenerativeAi` - Google Generative AI
- `AiBackend.claudeA2ui` - Claude via A2UI

---

## 🎨 What You'll See

### Backend Indicator Banner
When the app is running, you'll see which backend is active:

```
┌──────────────────────────────────┐
│ 🤖 Using: Firebase Vertex AI     │  ← This banner shows current backend
└──────────────────────────────────┘
```

### Settings Tooltip
Hover over the settings icon to see current backend:

```
┌──────────────────────────────────┐
│                              ⚙️ │
│  ↑ AI Backend: Firebase Vertex │  ← Tooltip
└──────────────────────────────────┘
```

### Error State
If a backend isn't configured properly:

```
┌──────────────────────────────────┐
│           ⚠️                     │
│      Backend Error               │
│                                  │
│  Missing API key. Please         │
│  configure GEMINI_API_KEY.       │
│                                  │
│   [Switch Backend]               │  ← Tap to choose another
└──────────────────────────────────┘
```

---

## 📋 Quick Reference

### Check Current Backend
- Look at the banner below the app bar: "Using: [Backend Name]"
- Or hover/tap the settings icon (⚙️)

### Switch Backend (UI)
1. Tap ⚙️
2. Tap "Switch Backend"
3. Select new backend
4. Done! (Choice is saved automatically)

### Switch Backend (Command Line)
```bash
flutter run --dart-define=DEFAULT_AI_BACKEND=<backend_name>
```

Backend names:
- `vertexAi`
- `googleGenerativeAi`
- `claudeA2ui`

---

## ✅ Backend Status Indicators

When you open the backend selector, you'll see:

| Icon | Meaning |
|------|---------|
| ✅ Green checkmark | Currently active backend |
| ○ Empty circle | Available but not selected |
| ○ Red text | Misconfigured (click to see error) |

---

## 🔄 Backend Persistence

Your backend choice is **automatically saved** and will be remembered:
- ✅ Across app restarts
- ✅ After hot reload/restart
- ✅ On all devices (using SharedPreferences)

To reset: Just switch to a different backend via the UI!

---

## 💡 Pro Tips

1. **Test Each Backend**: Try all three to see which works best for your use case
2. **Keep Vertex AI as Fallback**: It's already configured and reliable
3. **Development vs Production**: Use Google Gen AI for dev, Vertex AI for production
4. **A2UI for Claude**: Best when you need Claude's specific capabilities
5. **Watch for Errors**: If a backend fails, the app will show a clear error message

---

## 🆘 Troubleshooting

### "Missing API key" Error
**For Google Generative AI:**
```bash
flutter run --dart-define=GEMINI_API_KEY=your_key_here
```

### "Missing server URL" Error
**For Claude A2UI:**
1. Start the server: `cd a2ui_server_example && npm start`
2. Run app: `flutter run --dart-define=CLAUDE_A2UI_SERVER_URL=http://localhost:8080`

### Backend Won't Switch
- Check the Flutter console for error messages
- Make sure all required configuration is set
- Try restarting the app

### App Stuck Loading
- Tap ⚙️ → "Switch Backend"
- Select a different backend
- Check console for specific errors

---

## 📞 Need More Help?

- See [BACKEND_SETUP.md](BACKEND_SETUP.md) for detailed setup
- See [QUICK_START.md](QUICK_START.md) for quick reference
- See [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) for technical details

---

Happy switching! 🎉
