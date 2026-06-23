import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:habla/main.dart';

void main() {
  testWidgets('HablaApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: HablaApp()),
    );
    // App should render without throwing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
