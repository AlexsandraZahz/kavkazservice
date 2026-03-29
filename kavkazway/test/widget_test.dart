import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kavkazway/app/app.dart';

void main() {
  testWidgets('App builds correctly', (WidgetTester tester) async {
    await tester
        .pumpWidget(const KavkazWayApp()); // Измените MyApp на KavkazWayApp
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
