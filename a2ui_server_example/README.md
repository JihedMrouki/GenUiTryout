# A2UI Server for Claude Integration

This is an example Node.js server that implements the A2UI protocol to connect your GenUI Flutter app with Claude.

## Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Set Your Claude API Key

**Windows (PowerShell):**
```powershell
$env:ANTHROPIC_API_KEY="your-claude-api-key-here"
```

**macOS/Linux:**
```bash
export ANTHROPIC_API_KEY="your-claude-api-key-here"
```

Get your API key from: https://console.anthropic.com/settings/keys

### 3. Run the Server

```bash
npm start
```

The server will start on `http://localhost:8080`

### 4. Test the Server

```bash
curl http://localhost:8080/health
```

You should see:
```json
{"status":"healthy","backend":"claude-a2ui"}
```

## Usage with Flutter App

1. **Make sure this server is running**
2. **In your Flutter app:**
   - Tap the settings icon (⚙️)
   - Select "Switch Backend"
   - Choose "Claude (A2UI)"

3. **The Flutter app will now use Claude** through this server!

## How It Works

```
Flutter App → POST /generate → This Server → Claude API
                                     ↓
Flutter App ← A2UI Protocol ← This Server ← Claude Response
```

1. Flutter app sends user messages to this server
2. Server forwards them to Claude API with tool definitions
3. Claude responds with tool calls (widget definitions)
4. Server converts Claude's response to A2UI format
5. Flutter app renders the widgets

## Configuration

### Change Port

```bash
PORT=3000 npm start
```

Don't forget to update the Flutter app configuration:
```dart
// lib/config/ai_backend_config.dart
static String claudeA2uiServerUrl = 'http://localhost:3000';
```

### Change Claude Model

Edit `server.js` line 33:
```javascript
model: 'claude-3-5-sonnet-20241022',  // or 'claude-3-opus-20240229'
```

## Development

For auto-restart on file changes:

```bash
npm install -g nodemon
npm run dev
```

## Troubleshooting

### "ANTHROPIC_API_KEY not found"
- Make sure you've set the environment variable
- Or hardcode it in `server.js` (line 12) - **not recommended for production**

### "Connection refused" from Flutter app
- Ensure the server is running (`npm start`)
- Check the port matches your Flutter app configuration
- If running on a physical device, use your computer's IP instead of localhost

### CORS errors
- The server already has CORS enabled
- If still having issues, check your network firewall

## Production Deployment

For production, consider:
1. Using environment variables for API keys (never commit them!)
2. Adding authentication to your server endpoints
3. Implementing rate limiting
4. Adding proper error handling and logging
5. Using a process manager like PM2
6. Deploying to a cloud service (Heroku, Railway, Vercel, etc.)

## License

MIT
