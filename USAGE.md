# Usage Guide

## Environment Setup

This project uses environment variables to keep sensitive keys out of version control.

### Quick Setup

```bash
# 1. Copy the example env file
cp .env.example .env

# 2. Add your actual keys to .env
# 3. Run the app
./run.sh
```

---

## Environment Variables

### Required Variables

| Variable | Description | Where to get it |
|----------|-------------|-----------------|
| `REVENUECAT_ANDROID_KEY` | RevenueCat Google Play API key | [app.revenuecat.com](https://app.revenuecat.com) |
| `REVENUECAT_IOS_KEY` | RevenueCat App Store API key | [app.revenuecat.com](https://app.revenuecat.com) |

**Note:** Firebase is configured via config files (`google-services.json` and `GoogleService-Info.plist`), not environment variables. See Firebase setup section below.

---

## Running the App

### Development

```bash
# Using the helper script (loads .env automatically)
./run.sh

# OR manually with dart-define
flutter run \
  --dart-define=REVENUECAT_ANDROID_KEY=your_key \
  --dart-define=REVENUECAT_IOS_KEY=your_key
```

### Specific Device

```bash
# List devices
flutter devices

# Run on specific device
./run.sh -d <device_id>

# Example: Run on iPhone
./run.sh -d iphone

# Example: Run on Android emulator
./run.sh -d emulator
```

### Release Builds

```bash
# Android APK
flutter build apk \
  --dart-define=REVENUECAT_ANDROID_KEY=your_key \
  --dart-define=REVENUECAT_IOS_KEY=your_key

# Android App Bundle (for Play Store)
flutter build appbundle \
  --dart-define=REVENUECAT_ANDROID_KEY=your_key \
  --dart-define=REVENUECAT_IOS_KEY=your_key

# iOS (for App Store)
flutter build ios \
  --dart-define=REVENUECAT_ANDROID_KEY=your_key \
  --dart-define=REVENUECAT_IOS_KEY=your_key
```

---

## CI/CD Setup

### GitHub Actions Example

```yaml
- name: Run Flutter tests
  run: flutter test
  env:
    REVENUECAT_ANDROID_KEY: ${{ secrets.REVENUECAT_ANDROID_KEY }}
    REVENUECAT_IOS_KEY: ${{ secrets.REVENUECAT_IOS_KEY }}

- name: Build APK
  run: |
    flutter build apk \
      --dart-define=REVENUECAT_ANDROID_KEY=${{ secrets.REVENUECAT_ANDROID_KEY }} \
      --dart-define=REVENUECAT_IOS_KEY=${{ secrets.REVENUECAT_IOS_KEY }}
```

### Codemagic Setup

Add environment variables in Codemagic UI:
- `REVENUECAT_ANDROID_KEY`
- `REVENUECAT_IOS_KEY`

Then in build script:
```bash
flutter build apk \
  --dart-define=REVENUECAT_ANDROID_KEY=$REVENUECAT_ANDROID_KEY \
  --dart-define=REVENUECAT_IOS_KEY=$REVENUECAT_IOS_KEY
```

---

## Getting API Keys

### RevenueCat

1. Go to [app.revenuecat.com](https://app.revenuecat.com)
2. Create a project
3. Go to Settings → API Keys
4. Create keys for:
   - **Google Play**: `REVENUECAT_ANDROID_KEY` (starts with `goog_`)
   - **App Store**: `REVENUECAT_IOS_KEY` (starts with `appl_`)

### Firebase

Firebase Analytics and Crashlytics are configured for production monitoring.

#### Step 1: Create Firebase Project

1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Click "Add project" → Name it `delusions` (or your preferred name)
3. Disable Google Analytics (we'll enable it properly in the next steps)
4. Create project

#### Step 2: Add Android App

1. In Firebase Console, click the **Android icon**
2. Package name: Check `android/app/build.gradle.kts` for `applicationId` (default: `com.example.affirmations_app`)
3. Nickname: `Delusions Android`
4. Download `google-services.json`
5. Place it in `android/app/`
6. **Skip** the build script steps (already configured in this project)

#### Step 3: Add iOS App

1. In Firebase Console, click **+** → Add iOS app
2. Bundle ID: Check `ios/Runner.xcodeproj/project.pbxproj` for `PRODUCT_BUNDLE_IDENTIFIER`
3. Nickname: `Delusions iOS`
4. Download `GoogleService-Info.plist`
5. Place it in `ios/Runner/`
6. **Skip** the build script steps (already configured in this project)

#### Step 4: Install iOS Pods

```bash
cd ios
pod install
cd ..
```

#### Step 5: Run the App

```bash
flutter pub get
./run.sh
```

#### Step 6: Verify Setup

After running the app:
1. Go to Firebase Console → **Crashlytics**
2. You should see your app listed
3. Go to **Analytics** → **Dashboard** to see user activity

#### Testing Crashlytics

To test crash reporting, temporarily add to any button's `onPressed`:

```dart
FirebaseCrashlytics.instance.crash();
```

Remove the line after testing — crashes will appear in Firebase Console within minutes.

#### What You Get

| Firebase Feature | What it tracks |
|-----------------|----------------|
| **Analytics** | App opens, screen views, user engagement |
| **Crashlytics** | Crash reports, stack traces, affected users |
| **Dashboard** | Active users, sessions, retention metrics |

---

## Troubleshooting

### "Placeholder key" error

**Problem**: App still uses placeholder keys
**Solution**: Make sure you're running with `./run.sh` or using `--dart-define`

### iOS build fails

**Problem**: iOS build can't find Firebase config
**Solution**:
1. Make sure `GoogleService-Info.plist` is in `ios/Runner/`
2. Run `cd ios && pod install`

### RevenueCat not working

**Problem**: Premium features not unlocking
**Solution**:
1. Verify your keys are correct in RevenueCat dashboard
2. Check that Products/Entitlements are configured
3. Test with RevenueCat's tester mode

---

## Development Tips

### Hot Reload

Environment variables require a full restart, not hot reload:

```bash
# After changing .env, press:
# Then run:
./run.sh
```

### Multiple Environments

Create different env files:

```bash
# Development
cp .env.example .env.dev
# Edit with dev keys
./run.sh --env-file=.env.dev

# Production
cp .env.example .env.prod
# Edit with prod keys
flutter build apk --env-file=.env.prod
```

---

## File Structure Reference

```
affirmations_app/
├── lib/
│   └── config/
│       └── env.dart           # Env var loader (reads --dart-define)
├── .env.example              # Template (safe to commit)
├── .env                      # Your keys (NEVER commit)
├── .gitignore                # Ignores .env files
├── run.sh                    # Helper script
├── android/
│   └── app/
│       └── google-services.json  # Firebase Android config
└── ios/
    └── Runner/
        └── GoogleService-Info.plist  # Firebase iOS config
```
