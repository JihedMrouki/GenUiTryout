# 🚀 Quick Start: Multi-Backend GenUI App

Your app now supports **3 AI backends** that you can switch between at runtime!

## ✅ What's Been Set Up

### 1. **Firebase Vertex AI** (Ready to use!)
- ✅ Already configured
- ✅ No setup needed
- ✅ Works out of the box

### 2. **Google Generative AI** (Needs API key)
- ⚙️ Quick setup required
- 📝 Get API key from: https://aistudio.google.com/apikey

### 3. **Claude via A2UI** (Needs server)
- 🔧 Advanced setup required
- 📦 Example server provided in `a2ui_server_example/`

---

## 🎯 Quickest Way to Get Started

### Option 1: Use Vertex AI (Default - Already Works!)

```bash
flutter pub get
flutter run
```

That's it! The app will use Firebase Vertex AI.

### Option 2: Try Google Generative AI

1. Get API key from https://aistudio.google.com/apikey
2. Run with:
```bash
flutter run --dart-define=GEMINI_API_KEY=your_api_key_here
```
3. In the app: Tap ⚙️ → "Switch Backend" → Select "Google Generative AI"

### Option 3: Use Claude

1. Set up the A2UI server:
```bash
cd a2ui_server_example
npm install
export ANTHROPIC_API_KEY=your_claude_key
npm start
```

2. Run Flutter app:
```bash
flutter run --dart-define=CLAUDE_A2UI_SERVER_URL=http://localhost:8080
```

3. In the app: Tap ⚙️ → "Switch Backend" → Select "Claude (A2UI)"

---

## 🔄 Switching Backends

**At Runtime (No Restart Needed!):**
1. Tap the settings icon (⚙️) in the top-right corner
2. Select "Switch Backend"
3. Choose your backend
4. The app reinitializes instantly!

**Your choice is saved** and persists across app restarts.

---

## 📁 New Files Created

```
genui_demo/
├── lib/
│   ├── config/
│   │   ├── ai_backend_config.dart          ← Backend enum & settings
│   │   └── content_generator_factory.dart   ← Factory for creating generators
│   └── my_home_page.dart                    ← Updated with backend switching
├── a2ui_server_example/                     ← Example Claude server
│   ├── server.js                            ← Node.js A2UI server
│   ├── package.json                         ← npm dependencies
│   └── README.md                            ← Server setup guide
├── .env.example                             ← Environment variable template
├── BACKEND_SETUP.md                         ← Detailed setup guide
└── QUICK_START.md                           ← This file
```

---

## 🎨 UI Features

- **Settings Menu**: Tap ⚙️ icon to access backend switcher
- **Backend Indicator**: Shows current backend at top of screen
- **Error Handling**: Clear error messages if backend misconfigured
- **Real-time Switching**: Change backends without app restart

---

## 📖 Documentation

- **Detailed Setup Guide**: See [BACKEND_SETUP.md](BACKEND_SETUP.md)
- **A2UI Server Guide**: See [a2ui_server_example/README.md](a2ui_server_example/README.md)
- **Environment Variables**: See [.env.example](.env.example)

---

## 🐛 Common Issues

### "Missing API key" error
→ Run with: `flutter run --dart-define=GEMINI_API_KEY=your_key`

### "Missing server URL" error
→ Make sure A2UI server is running: `cd a2ui_server_example && npm start`

### App stuck loading
→ Check Flutter console for errors, or switch to a different backend

---

## 💡 Tips

1. **Start with Vertex AI** - It works immediately
2. **Test with Google Gen AI** - Easy to set up, just needs API key
3. **Experiment with Claude** - Full control, requires server setup
4. **Switch anytime** - Backends can be changed on-the-fly
5. **Settings persist** - Your choice is remembered

---

## 🎉 You're All Set!

Run the app and start exploring different AI backends:

```bash
flutter pub get
flutter run
```

Happy building! 🚀
