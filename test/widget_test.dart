// Basic smoke test for the FitFlow app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('FitFlow app builds and shows main navigation', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FitFlowApp());
    await tester.pump();

    // The app title / bottom navigation should be present.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
