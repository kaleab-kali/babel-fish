import 'package:babel_fish_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('plays the fixture caption flow', (tester) async {
    await tester.pumpWidget(const BabelFishApp());

    expect(find.text('Babel Fish'), findsOneWidget);
    expect(find.text('No source caption yet.'), findsOneWidget);
    expect(find.text('No translated caption yet.'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    expect(find.text('Hello, welcome to Babel Fish.'), findsOneWidget);
    expect(find.text('ሰላም፣ ወደ Babel Fish እንኳን በደህና መጡ።'), findsOneWidget);
    expect(find.textContaining('Perceived'), findsOneWidget);
  });
}
