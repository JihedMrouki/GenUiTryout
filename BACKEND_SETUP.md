# AI Backend Configuration Guide

This GenUI demo app supports multiple AI backends that you can switch between at runtime. This guide will help you set up and configure each backend.

## Available Backends

1. **Firebase Vertex AI** (Default) - Production-ready, requires Firebase project
2. **Google Generative AI** - Direct API access, quick setup with API key
3. **Claude (A2UI)** - Requires custom A2UI server implementation

---

## 🔧 Quick Start

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Configure Your Chosen Backend(s)

Follow the setup instructions below for the backend(s) you want to use.

---

## Backend Setup Instructions

### Option 1: Firebase Vertex AI (Default)

**Status:** ✅ Already configured in this project

**What you have:**
- Firebase project: `genui-demo-f2ba3`
- Configuration file: `lib/firebase_options.dart`
- Platforms: Web, Android, iOS, macOS, Windows

**No additional setup needed** - this backend is ready to use!

**To verify it's working:**
```bash
flutter run
```

---

### Option 2: Google Generative AI

**Best for:** Quick prototyping, testing without Firebase setup

#### Setup Steps:

1. **Get an API Key:**
   - Visit https://aistudio.google.com/apikey
   - Sign in with your Google account
   - Click "Create API key"
   - Copy your API key

2. **Configure the API Key:**

   **Option A: Using Environment Variable (Recommended)**
   ```bash
   # Windows (PowerShell)
   $env:GEMINI_API_KEY="your_api_key_here"
   flutter run --dart-define=GEMINI_API_KEY=your_api_key_here

   # macOS/Linux
   export GEMINI_API_KEY="your_api_key_here"
   flutter run --dart-define=GEMINI_API_KEY=your_api_key_here
   ```

   **Option B: Hardcode in Configuration File**

   Edit `lib/config/ai_backend_config.dart`:
   ```dart
   static String? googleGenerativeAiApiKey = 'your_api_key_here';
   ```

3. **Switch to Google Generative AI:**
   - Run the app
   - Tap the settings icon (⚙️) in the top-right
   - Select "Switch Backend"
   - Choose "Google Generative AI"

---

### Option 3: Claude (A2UI Protocol)

**Best for:** Using Claude or custom AI agents

This option requires you to set up an A2UI-compliant server that communicates with Claude.

#### Architecture:

```
Flutter App ←→ A2UI Server ←→ Claude API
```

#### Setup Steps:

##### Part 1: Create A2UI Server

You need to implement a server that:
1. Accepts A2UI protocol messages from the Flutter app
2. Communicates with Claude API (or any other AI)
3. Returns A2UI-formatted responses

**Example Node.js/Express Server:**

```javascript
// server.js
const express = require('express');
const Anthropic = require('@anthropic-ai/sdk');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
});

app.post('/generate', async (req, res) => {
  const { messages, catalog, systemInstruction } = req.body;

  try {
    const response = await anthropic.messages.create({
      model: 'claude-3-5-sonnet-20241022',
      max_tokens: 4096,
      system: systemInstruction,
      messages: messages,
      // Add tool definitions from catalog here
    });

    // Convert Claude response to A2UI format
    const a2uiResponse = convertToA2ui(response);
    res.json(a2uiResponse);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(8080, () => {
  console.log('A2UI server running on http://localhost:8080');
});
```

**Example Python/FastAPI Server:**

```python
# main.py
from fastapi import FastAPI
from anthropic import Anthropic
import os

app = FastAPI()
client = Anthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))

@app.post("/generate")
async def generate(request: dict):
    messages = request.get("messages", [])
    system_instruction = request.get("systemInstruction", "")

    response = client.messages.create(
        model="claude-3-5-sonnet-20241022",
        max_tokens=4096,
        system=system_instruction,
        messages=messages
    )

    # Convert Claude response to A2UI format
    a2ui_response = convert_to_a2ui(response)
    return a2ui_response
```

##### Part 2: Configure Flutter App

1. **Set Server URL:**

   **Option A: Environment Variable**
   ```bash
   flutter run --dart-define=CLAUDE_A2UI_SERVER_URL=http://localhost:8080
   ```

   **Option B: Hardcode in Configuration**

   Edit `lib/config/ai_backend_config.dart`:
   ```dart
   static String claudeA2uiServerUrl = 'http://localhost:8080';
   ```

2. **Start Your A2UI Server:**
   ```bash
   # Node.js
   node server.js

   # Python
   uvicorn main:app --port 8080
   ```

3. **Switch to Claude Backend:**
   - Run the app
   - Tap the settings icon (⚙️)
   - Select "Switch Backend"
   - Choose "Claude (A2UI)"

#### A2UI Protocol Resources:

- **A2UI Specification:** https://github.com/google/A2UI
- **GenUI A2UI Package:** https://pub.dev/packages/genui_a2ui
- **Documentation:** https://developers.googleblog.com/introducing-a2ui-an-open-project-for-agent-driven-interfaces/

---

## 🎯 Runtime Backend Switching

Once you've configured your backends, you can switch between them at any time:

1. **Via UI (Recommended):**
   - Tap the settings icon (⚙️) in the app bar
   - Select "Switch Backend"
   - Choose your desired backend
   - The app will reinitialize with the new backend

2. **Via Environment Variable (Launch Time):**
   ```bash
   flutter run --dart-define=DEFAULT_AI_BACKEND=googleGenerativeAi
   # Options: vertexAi, googleGenerativeAi, claudeA2ui
   ```

3. **Your selection is saved** and will persist across app restarts

---

## 🔍 Backend Comparison

| Feature | Vertex AI | Google Gen AI | Claude (A2UI) |
|---------|-----------|---------------|---------------|
| **Setup Complexity** | Medium | Easy | Advanced |
| **API Key Required** | No (Firebase) | Yes | Yes (Server) |
| **Production Ready** | ✅ Yes | ⚠️ Limited | ✅ Yes (with server) |
| **Cost** | Firebase pricing | Pay-per-use | Pay-per-use + Server |
| **Latency** | Low | Low | Medium (extra hop) |
| **Model** | Gemini | Gemini | Claude / Custom |
| **Best For** | Production apps | Quick testing | Custom AI agents |

---

## 🐛 Troubleshooting

### "Missing API key" Error

**For Google Generative AI:**
- Ensure you've set `GEMINI_API_KEY` environment variable
- Or hardcoded it in `ai_backend_config.dart`
- Verify the API key is valid at https://aistudio.google.com/apikey

### "Missing server URL" Error

**For Claude A2UI:**
- Ensure your A2UI server is running
- Check the server URL is correct (default: `http://localhost:8080`)
- Test the server directly with curl:
  ```bash
  curl http://localhost:8080/health
  ```

### App Stuck on Loading

- Check the Flutter console for error messages
- Tap the settings icon to see if there's a backend error
- Try switching to a different backend
- Verify your internet connection

### Backend Unavailable

- Check console logs for specific error messages
- Ensure all API keys and configurations are correct
- For A2UI: Verify the server is accessible from your device

---

## 📝 Configuration Files

- **`lib/config/ai_backend_config.dart`** - Backend enum and settings
- **`lib/config/content_generator_factory.dart`** - Factory for creating generators
- **`.env.example`** - Example environment variables
- **`lib/firebase_options.dart`** - Firebase configuration (auto-generated)

---

## 🚀 Running with Different Backends

```bash
# Run with Vertex AI (default)
flutter run

# Run with Google Generative AI
flutter run --dart-define=GEMINI_API_KEY=your_key --dart-define=DEFAULT_AI_BACKEND=googleGenerativeAi

# Run with Claude A2UI
flutter run --dart-define=CLAUDE_A2UI_SERVER_URL=http://localhost:8080 --dart-define=DEFAULT_AI_BACKEND=claudeA2ui
```

---

## 💡 Tips

1. **Start with Vertex AI** - It's already configured and works out of the box
2. **Use Google Generative AI** for quick testing without Firebase overhead
3. **Implement Claude A2UI** when you need Claude's capabilities or want a custom AI backend
4. **Backend selection persists** - Your choice is saved using SharedPreferences
5. **Switch anytime** - You can change backends on-the-fly without restarting the app

---

## 🆘 Need Help?

- **GenUI Documentation:** https://docs.flutter.dev/ai/genui
- **GenUI GitHub:** https://github.com/flutter/genui
- **A2UI Specification:** https://github.com/google/A2UI
- **Firebase Setup:** https://firebase.google.com/docs/flutter/setup
- **Google AI Studio:** https://aistudio.google.com

---

Happy coding! 🎉
