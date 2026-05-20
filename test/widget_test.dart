import 'package:flutter_test/flutter_test.dart';
import 'package:techstore_flutter/main.dart';

void main() {
  testWidgets('TechStore app loads home', (WidgetTester tester) async {
    await tester.pumpWidget(const TechStoreApp());
    await tester.pumpAndSettle();

    expect(find.text('TechStore'), findsWidgets);
  });
}
