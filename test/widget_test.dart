import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snapprice_ai/main.dart';

void main() {
  testWidgets('renders app and allows filtering interaction', (WidgetTester tester) async {
    await tester.pumpWidget(const SnapPriceApp());

    expect(find.text('SnapPrice AI'), findsOneWidget);
    expect(find.text('Comparador inteligente de precios'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Arroz');
    await tester.pump();

    expect(find.text('Arroz 1kg'), findsOneWidget);
  });
}
