# Firebase Configuration Setup

## ⚠️ Important: Firebase Options File

The `lib/firebase_options.dart` file contains **sensitive information** including:
- Firebase API keys
- Project IDs
- App IDs
- Storage bucket names

**This file is now in `.gitignore` to prevent accidental exposure of your Firebase credentials.**

---

## 🔧 Setting Up Firebase for a New Project

If you're cloning this project or setting up Firebase for the first time:

### Option 1: Use FlutterFire CLI (Recommended)

1. **Install FlutterFire CLI:**
```bash
dart pub global activate flutterfire_cli
```

2. **Configure Firebase:**
```bash
flutterfire configure
```

This will:
- Prompt you to select/create a Firebase project
- Automatically generate `lib/firebase_options.dart`
- Configure all platforms (Web, Android, iOS, macOS, Windows)

### Option 2: Manual Configuration

1. **Copy the template:**
```bash
cp lib/firebase_options.dart.template lib/firebase_options.dart
```

2. **Get your Firebase configuration:**
   - Go to [Firebase Console](https://console.firebase.google.com)
   - Select your project
   - Go to Project Settings
   - Scroll to "Your apps" section
   - Copy configuration for each platform

3. **Update `lib/firebase_options.dart`:**
   - Replace all `YOUR_*` placeholders with actual values from Firebase Console
   - Update for each platform you're targeting

---

## 🔐 Security Best Practices

### For Development

1. **Keep `firebase_options.dart` out of version control** ✅ (already in .gitignore)
2. **Share the template** (`firebase_options.dart.template`) instead
3. **Document setup steps** in your README

### For Team Projects

Each team member should:
1. Run `flutterfire configure` with their own Firebase project
2. Or get the `firebase_options.dart` file through secure channels (not git)

### For Production

1. **Use separate Firebase projects** for dev/staging/prod
2. **Use environment-specific configurations**
3. **Implement API key restrictions** in Firebase Console:
   - Restrict by bundle ID (iOS/Android)
   - Restrict by HTTP referrers (Web)
   - Restrict by IP addresses (if applicable)

---

## 📋 What's in firebase_options.dart

The file contains platform-specific Firebase configurations:

```dart
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Returns the correct config based on platform
  }

  static const FirebaseOptions web = FirebaseOptions(...);
  static const FirebaseOptions android = FirebaseOptions(...);
  static const FirebaseOptions ios = FirebaseOptions(...);
  static const FirebaseOptions macos = FirebaseOptions(...);
  static const FirebaseOptions windows = FirebaseOptions(...);
}
```

---

## 🚨 If You Accidentally Committed firebase_options.dart

If you've already committed this file to git:

1. **Remove it from git history:**
```bash
git rm --cached lib/firebase_options.dart
git commit -m "Remove firebase_options.dart from tracking"
git push
```

2. **Rotate your Firebase API keys:**
   - Go to Firebase Console → Project Settings
   - Delete the exposed keys
   - Create new ones
   - Update your local `firebase_options.dart`

3. **Ensure .gitignore is working:**
```bash
git check-ignore -v lib/firebase_options.dart
# Should show: .gitignore:56:lib/firebase_options.dart
```

---

## 🎯 Quick Setup Summary

**For new developers:**

```bash
# 1. Install FlutterFire CLI
dart pub global activate flutterfire_cli

# 2. Configure Firebase
flutterfire configure

# 3. Select your Firebase project (or create new one)
# 4. Select platforms to configure
# 5. Done! firebase_options.dart is generated
```

**Alternative (if you have the config):**

```bash
# Get firebase_options.dart from your team lead securely
# Place it in lib/firebase_options.dart
# Run the app
flutter run
```

---

## 🔄 Using Different Firebase Projects

### For Development vs Production

You can maintain multiple Firebase configuration files:

```
lib/
├── firebase_options.dart         # Default (gitignored)
├── firebase_options.dev.dart     # Development (gitignored)
├── firebase_options.prod.dart    # Production (gitignored)
└── firebase_options.dart.template # Template (committed)
```

Then in `main.dart`, load based on environment:

```dart
import 'firebase_options.dart' as firebase_options;
// or
import 'firebase_options.dev.dart' as firebase_options;

void main() async {
  await Firebase.initializeApp(
    options: firebase_options.DefaultFirebaseOptions.currentPlatform,
  );
  // ...
}
```

---

## ✅ Checklist

Before deploying or sharing your project:

- [ ] `firebase_options.dart` is in `.gitignore`
- [ ] Template file (`firebase_options.dart.template`) is available
- [ ] Setup instructions are documented
- [ ] Team members know how to generate their own configs
- [ ] API key restrictions are configured in Firebase Console
- [ ] Separate projects for dev/staging/prod (if applicable)

---

## 📚 Resources

- **FlutterFire CLI:** https://firebase.flutter.dev/docs/cli
- **Firebase Console:** https://console.firebase.google.com
- **Firebase Security Rules:** https://firebase.google.com/docs/rules
- **API Key Best Practices:** https://firebase.google.com/docs/projects/api-keys

---

## 🆘 Need Help?

**Common Issues:**

1. **"Firebase not initialized" error**
   - Ensure `firebase_options.dart` exists
   - Run `flutterfire configure`

2. **"Invalid API key" error**
   - Check your Firebase project settings
   - Verify platform-specific configurations

3. **"Default FirebaseApp has already been configured"**
   - This is usually fine, Firebase is already initialized

---

Made with 🔐 for secure Firebase configuration
