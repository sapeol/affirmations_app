import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:affirmations_app/widgets/swipe_card.dart';
import 'package:affirmations_app/models/affirmation.dart';
import 'package:affirmations_app/models/user_preferences.dart';

void main() {
  testWidgets('SwipeCard triggers onSwipe when swiped right', (WidgetTester tester) async {
    bool? swipedRight;
    
    final affirmation = Affirmation(text: 'Test Affirmation');
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SwipeCard(
          affirmation: affirmation,
          language: DopeLanguage.en,
          onSwipe: (isLike) {
            swipedRight = isLike;
          },
        ),
      ),
    ));

    // Drag the card to the right
    await tester.drag(find.byType(SwipeCard), const Offset(500, 0));
    await tester.pumpAndSettle();

    expect(swipedRight, isTrue);
  });

  testWidgets('SwipeCard triggers onSwipe when swiped left', (WidgetTester tester) async {
    bool? swipedRight;
    
    final affirmation = Affirmation(text: 'Test Affirmation');
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SwipeCard(
          affirmation: affirmation,
          language: DopeLanguage.en,
          onSwipe: (isLike) {
            swipedRight = isLike;
          },
        ),
      ),
    ));

    // Drag the card to the left
    await tester.drag(find.byType(SwipeCard), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(swipedRight, isFalse);
  });
}
