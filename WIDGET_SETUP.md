# Home Widget Setup Guide

To make the daily affirmations widget functional on home screens, follow these platform-specific steps:

## Android Setup

1. Create a new file `android/app/src/main/kotlin/com/example/affirmations_app/AffirmationWidgetProvider.kt`.
2. Implement `AppWidgetProvider` to read from `SharedPreferences` (where `home_widget` saves data).
3. Register the provider in `AndroidManifest.xml`.
4. Create the layout XML in `android/app/src/main/res/layout/affirmation_widget.xml`.

## iOS Setup

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Add a new "Widget Extension" target named `AffirmationWidget`.
3. In the generated SwiftUI file, use `UserDefaults` with a shared App Group to read the `affirmation_text`.
4. Configure App Groups for both the main app and the widget extension in the "Signing & Capabilities" tab.

## Data Keys

The app currently saves the affirmation text using the key:
- `affirmation_text`

You can use this key in your native code to retrieve and display the text.
