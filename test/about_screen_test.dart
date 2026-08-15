import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dittmanga/features/about/presentation/about_screen.dart';
import 'package:dittmanga/core/network/local_data_source.dart';

void main() {
  testWidgets('AboutScreen shows correct information', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'doh_bypass': false});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(
          home: AboutScreen(),
        ),
      ),
    );

    expect(find.text('About & Settings'), findsOneWidget);
    expect(find.text('Manga App'), findsOneWidget);
    expect(find.text('v1.0.0'), findsOneWidget);
    expect(find.text('Powered by Jikan API v4'), findsOneWidget);
  });
}
