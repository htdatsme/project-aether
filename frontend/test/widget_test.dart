import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Aether Home Screen Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: AetherApp()));
    await tester.pump(const Duration(seconds: 1)); // Give it time to render

    // Verify that the title is present.
    expect(find.text('AETHER'), findsOneWidget);
    expect(find.text('BEGIN CONSULTATION'), findsOneWidget);
  });
}
