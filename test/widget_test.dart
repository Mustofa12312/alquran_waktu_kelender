// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:muslim_time_one/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await initializeDateFormatting('id_ID', null);
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MuslimTimeApp()));

    // Verify that the app builds without crashing.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
