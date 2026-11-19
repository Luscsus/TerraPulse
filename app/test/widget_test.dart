import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:terrapulse_app/main.dart';

void main() {
  testWidgets('TerraPulse empty garden placeholder renders', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TerraPulseApp());

    expect(find.text('TerraPulse'), findsOneWidget);
    expect(find.text('Your garden is empty'), findsOneWidget);
    expect(find.text('Add Your First Plant'), findsOneWidget);
    expect(find.byIcon(Icons.eco_outlined), findsOneWidget);
  });
}
