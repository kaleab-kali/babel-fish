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

  testWidgets('switches the fixture target language', (tester) async {
    await tester.pumpWidget(const BabelFishApp());

    await tester.tap(find.byKey(const Key('target-language-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('French (Francais)').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    expect(find.text('Hello, welcome to Babel Fish.'), findsOneWidget);
    expect(find.text('Bonjour, bienvenue dans Babel Fish.'), findsOneWidget);
  });

  testWidgets('switches the fixture source language', (tester) async {
    await tester.pumpWidget(const BabelFishApp());

    await tester.tap(find.byKey(const Key('source-language-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Amharic (አማርኛ)').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    expect(find.text('ሰላም፣ ወደ Babel Fish እንኳን በደህና መጡ።'), findsOneWidget);
    expect(find.text('Hello, welcome to Babel Fish.'), findsOneWidget);
  });
}
