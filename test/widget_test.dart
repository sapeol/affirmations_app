import 'package:flutter_test/flutter_test.dart';
import 'package:affirmations_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(onboardingCompleted: false));

    // Verify that onboarding is shown (e.g., check for "DELUSIONS")
    expect(find.text('DELUSIONS'), findsOneWidget);
  });
}