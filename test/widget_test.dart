import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_code/app.dart';

void main() {
  testWidgets('Splash to Onboarding smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify splash page shows
    expect(find.text('GSTSOF'), findsOneWidget);

    // Advance time past splash to onboarding
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify onboarding page 1 shows
    expect(find.text('Masters & Inventory Hub'), findsOneWidget);
  });
}
