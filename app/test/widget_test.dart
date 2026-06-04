import 'package:babel_fish_app/main.dart';
import 'package:babelfish_core/babelfish_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('plays the fixture caption flow', (tester) async {
    await tester.pumpWidget(const BabelFishApp());

    expect(find.text('Babel Fish'), findsOneWidget);
    expect(find.byKey(const Key('fixture-mode-banner')), findsOneWidget);
    expect(find.text('Fixture mode'), findsOneWidget);
    expect(
      find.text('Offline demo data only. No microphone, network, or API keys.'),
      findsOneWidget,
    );
    expect(find.text('Session idle'), findsOneWidget);
    expect(find.text('No source caption yet.'), findsOneWidget);
    expect(find.text('No translated caption yet.'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    expect(find.textContaining('Session completed'), findsOneWidget);
    expect(find.text('Hello, welcome to Babel Fish.'), findsWidgets);
    expect(find.text('ሰላም፣ ወደ Babel Fish እንኳን በደህና መጡ።'), findsWidgets);
    await tester.scrollUntilVisible(find.textContaining('Perceived'), 300);
    await tester.pumpAndSettle();

    expect(find.textContaining('Perceived'), findsOneWidget);
  });

  testWidgets('switches the fixture target language', (tester) async {
    await tester.pumpWidget(const BabelFishApp());

    await tester.tap(find.byKey(const Key('target-language-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('French (Français)').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    expect(find.text('Hello, welcome to Babel Fish.'), findsWidgets);
    expect(find.text('Bonjour, bienvenue dans Babel Fish.'), findsWidgets);
  });

  testWidgets('switches the fixture source language', (tester) async {
    await tester.pumpWidget(const BabelFishApp());

    await tester.tap(find.byKey(const Key('source-language-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Amharic (አማርኛ)').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    expect(find.text('ሰላም፣ ወደ Babel Fish እንኳን በደህና መጡ።'), findsWidgets);
    expect(find.text('Hello, welcome to Babel Fish.'), findsWidgets);
  });

  testWidgets('advances through fixture transcript segments', (tester) async {
    await tester.pumpWidget(const BabelFishApp());

    await tester.tap(find.byKey(const Key('target-language-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('French (Français)').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    expect(
      find.text('This offline demo keeps captions predictable.'),
      findsWidgets,
    );
    expect(
      find.text('Cette démo hors ligne garde les sous-titres prévisibles.'),
      findsWidgets,
    );
  });

  testWidgets('copies the translated caption', (tester) async {
    final platformCalls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') {
            platformCalls.add(call);
          }
          return null;
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    await tester.pumpWidget(const BabelFishApp());

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('copy-translation-button')),
      300,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('copy-translation-button')));
    await tester.pump();

    expect(platformCalls, hasLength(1));
    expect(
      platformCalls.single.arguments,
      containsPair('text', 'ሰላም፣ ወደ Babel Fish እንኳን በደህና መጡ።'),
    );
    expect(find.text('Copied translation'), findsOneWidget);
  });

  testWidgets('records completed fixture translations in history', (
    tester,
  ) async {
    await tester.pumpWidget(const BabelFishApp());

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('caption-history-list')),
      300,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('caption-history-list')), findsOneWidget);
    expect(find.byKey(const Key('caption-history-item-0')), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const Key('target-language-dropdown')),
      -300,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('target-language-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('French (Français)').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('caption-history-item-1')),
      300,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('caption-history-item-0')), findsOneWidget);
    expect(find.byKey(const Key('caption-history-item-1')), findsOneWidget);
    expect(
      find.text('Cette démo hors ligne garde les sous-titres prévisibles.'),
      findsWidgets,
    );
    expect(find.textContaining('English -> French'), findsOneWidget);
    expect(find.textContaining('English -> Amharic'), findsOneWidget);
  });

  testWidgets('clears completed fixture translation history', (tester) async {
    await tester.pumpWidget(const BabelFishApp());

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('clear-caption-history-button')),
      300,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('clear-caption-history-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('caption-history-list')), findsNothing);
    expect(find.text('Hello, welcome to Babel Fish.'), findsOneWidget);
  });

  testWidgets('exposes captions and latency with readable semantics', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(const BabelFishApp());

      expect(
        tester.getSemantics(find.byKey(const Key('fixture-mode-banner'))),
        matchesSemantics(
          label: 'Fixture mode status',
          value: 'Offline demo data only. No microphone, network, or API keys.',
          textDirection: TextDirection.ltr,
        ),
      );
      expect(
        tester.getSemantics(find.byKey(const Key('session-status-semantics'))),
        matchesSemantics(
          label: 'Speech session status',
          value: 'Session idle',
          textDirection: TextDirection.ltr,
        ),
      );
      expect(
        tester.getSemantics(find.byKey(const Key('source-caption-semantics'))),
        matchesSemantics(
          label: 'Source caption',
          value: 'No source caption yet.',
          textDirection: TextDirection.ltr,
        ),
      );
      expect(
        tester.getSemantics(
          find.byKey(const Key('translation-caption-semantics')),
        ),
        matchesSemantics(
          label: 'Translation caption',
          value: 'No translated caption yet.',
          textDirection: TextDirection.ltr,
        ),
      );
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(find.byKey(const Key('source-caption-semantics'))),
        matchesSemantics(
          label: 'Source caption',
          value: 'Hello, welcome to Babel Fish.',
          textDirection: TextDirection.ltr,
        ),
      );
      expect(
        tester.getSemantics(
          find.byKey(const Key('translation-caption-semantics')),
        ),
        matchesSemantics(
          label: 'Translation caption',
          value: 'ሰላም፣ ወደ Babel Fish እንኳን በደህና መጡ።',
          textDirection: TextDirection.ltr,
        ),
      );

      await tester.scrollUntilVisible(
        find.byKey(const Key('perceived-latency-semantics')),
        300,
      );
      await tester.pumpAndSettle();

      final perceivedLatencySemantics = tester
          .getSemantics(find.byKey(const Key('perceived-latency-semantics')))
          .getSemanticsData();
      expect(perceivedLatencySemantics.label, 'Perceived latency');
      expect(perceivedLatencySemantics.value, endsWith(' ms'));
      expect(perceivedLatencySemantics.value, isNot('-- ms'));
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('surfaces injected translation service errors', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FixtureCaptionPage(
          translationService: _FailingTranslationService(),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.textContaining('translation unavailable'),
      300,
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('translation unavailable'), findsOneWidget);
    expect(find.textContaining('Session failed'), findsOneWidget);
    expect(find.text('No translated caption yet.'), findsOneWidget);
  });
}

final class _FailingTranslationService implements TranslationService {
  const _FailingTranslationService();

  @override
  Future<TranslationResult> translate({
    required TranscriptSegment segment,
    required BabelLanguage targetLanguage,
  }) async {
    throw StateError('translation unavailable');
  }
}
