import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_photo_generator/main.dart';

void main() {
  testWidgets('Home page smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Wait for the navigation to settle
    await tester.pumpAndSettle();

    // Verify that we are on the Home Page
    expect(find.text('HomePage'), findsOneWidget);
    expect(find.text('HomeFeature'), findsOneWidget);
    
    // Verify counter starts at 0
    expect(find.text('Count: 0'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('Count: 1'), findsOneWidget);
  });
}
