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

### Optional Variables (Firebase)

| Variable | Description |
|----------|-------------|
| `FIREBASE_ANDROID_API_KEY` | Firebase Android API key |
| `FIREBASE_IOS_API_KEY` | Firebase iOS API key |

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

1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Create project "Delusions"
3. Add Android app → Download `google-services.json` → Place in `android/app/`
4. Add iOS app → Download `GoogleService-Info.plist` → Place in `ios/Runner/`

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
