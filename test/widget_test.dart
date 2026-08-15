import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dittmanga/app/app.dart';
import 'package:dittmanga/core/network/local_data_source.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MangaApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that the app builds and shows Home.
    expect(find.text('Top Rated'), findsOneWidget);
    expect(find.text('Latest Updates'), findsOneWidget);
  });
}
