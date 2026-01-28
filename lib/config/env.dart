/// Environment configuration
///
/// Uses --dart-define flags at build/run time:
/// flutter run --dart-define=REVENUECAT_ANDROID_KEY=xxx --dart-define=REVENUECAT_IOS_KEY=xxx
///
/// For development, create a `.env` file locally (gitignored) and use a script.
class Env {
  /// RevenueCat Android API Key
  static String get revenueCatAndroidKey =>
      const String.fromEnvironment('REVENUECAT_ANDROID_KEY',
        defaultValue: 'goog_placeholder');

  /// RevenueCat iOS API Key
  static String get revenueCatiOSKey =>
      const String.fromEnvironment('REVENUECAT_IOS_KEY',
        defaultValue: 'appl_placeholder');

  /// Get the appropriate RevenueCat key for the current platform
  static String getRevenueCatKey(bool isAndroid) {
    return isAndroid ? revenueCatAndroidKey : revenueCatiOSKey;
  }
}
