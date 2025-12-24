# Cultural Trip Planner Setup Guide

This guide will help you set up Firebase for your Cultural Trip Planner app using GenUI.

## Prerequisites

1. Flutter SDK installed
2. A Google account for Firebase

## Step 1: Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

## Step 2: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter a project name (e.g., "cultural-trip-planner")
4. Follow the steps to create your project

## Step 3: Enable Vertex AI (Gemini API)

1. In your Firebase project, go to "Build" → "Vertex AI in Firebase"
2. Click "Get started" or "Enable"
3. Accept the terms and enable the API

## Step 4: Configure Firebase for Your App

Run this command in your project directory:

```bash
flutterfire configure
```

This will:
- Automatically detect your Firebase projects
- Let you select the project you created
- Generate the proper `firebase_options.dart` file with all platform configurations
- Set up the necessary Firebase configuration files

When prompted:
- Select your Firebase project
- Choose the platforms you want to support (Android, iOS, Web, Windows, macOS)

## Step 5: Install Dependencies

```bash
flutter pub get
```

## Step 6: Platform-Specific Setup

### For Web
No additional setup needed!

### For Android
The `flutterfire configure` command already set up the required files.

### For iOS/macOS
The `flutterfire configure` command already set up the required files.

For iOS/macOS, you may also need to add network permissions. Add this to your entitlements file:
```xml
<key>com.apple.security.network.client</key>
<true/>
```

## Step 7: Run the App

```bash
flutter run
```

## How the App Works

1. **AI-Powered Interface**: The app uses Firebase Vertex AI (Gemini) to generate dynamic UIs based on user requests
2. **Cultural Trip Planning**: Ask about any destination (Paris, Rome, Carthage, Budapest, etc.)
3. **Interactive**: The AI creates beautiful, interactive interfaces with cards, lists, and actionable information

## Example Queries

Try asking:
- "Tell me about visiting Paris"
- "Plan a 3-day trip to Rome"
- "What are the must-see sites in Carthage?"
- "Best museums in Budapest"
- "Cultural festivals in Tokyo"

## Troubleshooting

### "Firebase not initialized" error
Make sure you ran `flutterfire configure` and that `firebase_options.dart` exists.

### "API key not found" error
Verify that Vertex AI is enabled in your Firebase Console.

### Network errors
Ensure you have internet connectivity and that Vertex AI API is properly enabled.

## Next Steps

- Customize the system instructions in `my_home_page.dart` to change the AI's behavior
- Add custom widgets to the catalog for more specialized UI components
- Implement user preferences and saved trips
- Add maps integration for visual trip planning

Enjoy planning your cultural adventures!
