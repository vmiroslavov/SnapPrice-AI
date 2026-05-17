import 'package:flutter_test/flutter_test.dart';
import 'package:snapprice_ai/main.dart';

void main() {
  testWidgets('renders base app message', (WidgetTester tester) async {
    await tester.pumpWidget(const SnapPriceApp());

    expect(find.text('SnapPrice AI'), findsOneWidget);
    expect(find.text('Proyecto Flutter base listo ✅'), findsOneWidget);
  });
}
