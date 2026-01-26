import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:affirmations_app/widgets/swipe_card.dart';
import 'package:affirmations_app/models/affirmation.dart';
import 'package:affirmations_app/models/user_preferences.dart';

void main() {
  testWidgets('SwipeCard triggers onSwipe with right direction when swiped right', (WidgetTester tester) async {
    SwipeDirection? swipedDirection;
    
    final affirmation = Affirmation(text: 'Test Affirmation');
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SwipeCard(
          affirmation: affirmation,
          language: DopeLanguage.en,
          onSwipe: (direction) async {
            swipedDirection = direction;
            return true;
          },
        ),
      ),
    ));

    await tester.drag(find.byType(SwipeCard), const Offset(500, 0));
    await tester.pumpAndSettle();

    expect(swipedDirection, SwipeDirection.right);
  });

  testWidgets('SwipeCard triggers onSwipe with left direction when swiped left', (WidgetTester tester) async {
    SwipeDirection? swipedDirection;
    
    final affirmation = Affirmation(text: 'Test Affirmation');
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SwipeCard(
          affirmation: affirmation,
          language: DopeLanguage.en,
          onSwipe: (direction) async {
            swipedDirection = direction;
            return true;
          },
        ),
      ),
    ));

    await tester.drag(find.byType(SwipeCard), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(swipedDirection, SwipeDirection.left);
  });
}
