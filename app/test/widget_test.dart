import 'dart:async';

import 'package:babel_fish_app/main.dart';
import 'package:babelfish_core/babelfish_core.dart';
import 'package:babelfish_fixtures/babelfish_fixtures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:babel_fish_app/src/runtime_config.dart';

void main() {
  test('defaults to fixture runtime mode', () {
    final config = BabelFishRuntimeConfig.fromEnvironment();

    expect(config.mode, BabelFishRuntimeMode.fixture);
  });

  test('accepts explicit fixture runtime mode', () {
    final config = BabelFishRuntimeConfig.fromEnvironment(mode: 'fixture');

    expect(config.mode, BabelFishRuntimeMode.fixture);
  });

  test('rejects unsupported runtime modes', () {
    expect(
      () => BabelFishRuntimeConfig.fromEnvironment(mode: 'live'),
      throwsUnsupportedError,
    );
  });

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

  testWidgets('swaps a supported fixture language pair', (tester) async {
    await tester.pumpWidget(const BabelFishApp());

    await tester.tap(find.byKey(const Key('swap-languages-button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    final reverseTranslation = fixtureTranslations.singleWhere(
      (translation) =>
          translation.sourceLanguage == FixtureLanguages.amharic &&
          translation.targetLanguage == FixtureLanguages.english,
    );
    expect(find.text(reverseTranslation.sourceText), findsWidgets);
    expect(find.text(reverseTranslation.translatedText), findsWidgets);
  });

  testWidgets('stacks language controls on narrow screens', (tester) async {
    _setTestViewSize(tester, const Size(390, 844));

    await tester.pumpWidget(const BabelFishApp());

    expect(find.byIcon(Icons.swap_vert), findsOneWidget);
    expect(find.byIcon(Icons.swap_horiz), findsNothing);
  });

  testWidgets('lays out language controls horizontally on wide screens', (
    tester,
  ) async {
    _setTestViewSize(tester, const Size(900, 700));

    await tester.pumpWidget(const BabelFishApp());

    expect(find.byIcon(Icons.swap_horiz), findsOneWidget);
    expect(find.byIcon(Icons.swap_vert), findsNothing);
  });

  testWidgets('disables swap when the reverse fixture pair is unavailable', (
    tester,
  ) async {
    await tester.pumpWidget(const BabelFishApp());

    await tester.tap(find.byKey(const Key('target-language-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(FixtureLanguages.french.displayName).last);
    await tester.pumpAndSettle();

    final swapButton = tester.widget<IconButton>(
      find.byKey(const Key('swap-languages-button')),
    );
    expect(swapButton.onPressed, isNull);
  });

  testWidgets('disables session controls while translation is in progress', (
    tester,
  ) async {
    final translationService = _DeferredTranslationService();
    await tester.pumpWidget(
      MaterialApp(
        home: FixtureCaptionPage(translationService: translationService),
      ),
    );

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pump();

    expect(find.text('Listening'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(
      tester
          .widget<DropdownButtonFormField<BabelLanguage>>(
            _languageDropdownField('source-language-dropdown'),
          )
          .onChanged,
      isNull,
    );
    expect(
      tester
          .widget<DropdownButtonFormField<BabelLanguage>>(
            _languageDropdownField('target-language-dropdown'),
          )
          .onChanged,
      isNull,
    );
    expect(
      tester.widget<IconButton>(find.byKey(const Key('swap-languages-button'))),
      isA<IconButton>().having((button) => button.onPressed, 'onPressed', null),
    );

    translationService.complete(
      TranslationResult(
        sourceSegment: translationService.segment!,
        targetLanguage: translationService.targetLanguage!,
        text: 'Deferred translation complete.',
        completedAt: DateTime.utc(2026, 1, 1, 12),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Play fixture'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );
    expect(find.text('Deferred translation complete.'), findsWidgets);
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

  testWidgets('limits completed fixture translation history', (tester) async {
    await tester.pumpWidget(const BabelFishApp());

    for (var index = 0; index < 12; index += 1) {
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pumpAndSettle();
    }

    await tester.scrollUntilVisible(
      find.byKey(const Key('caption-history-list')),
      300,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('caption-history-list')), findsOneWidget);
    for (var index = 0; index < 10; index += 1) {
      expect(find.byKey(Key('caption-history-item-$index')), findsOneWidget);
    }
    expect(find.byKey(const Key('caption-history-item-10')), findsNothing);
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
      find.text('Translation failed. Try the fixture again.'),
      300,
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Translation failed. Try the fixture again.'),
      findsOneWidget,
    );
    expect(find.textContaining('translation unavailable'), findsNothing);
    expect(find.textContaining('Session failed'), findsOneWidget);
    expect(find.text('No translated caption yet.'), findsOneWidget);
  });

  testWidgets('clears transient translation errors after a successful retry', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FixtureCaptionPage(
          translationService: _FailsOnceTranslationService(),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Translation failed. Try the fixture again.'),
      300,
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Translation failed. Try the fixture again.'),
      findsOneWidget,
    );
    expect(find.textContaining('temporary translation outage'), findsNothing);
    expect(find.textContaining('Session failed'), findsOneWidget);

    await tester.scrollUntilVisible(find.byIcon(Icons.mic), -300);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    expect(
      find.text('Translation failed. Try the fixture again.'),
      findsNothing,
    );
    expect(find.textContaining('Session completed'), findsOneWidget);
    expect(find.text('No translated caption yet.'), findsNothing);
  });

  testWidgets('surfaces injected transcription service errors', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FixtureCaptionPage(
          transcriptionService: _FailingTranscriptionService(),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Transcription failed. Try the fixture again.'),
      300,
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Transcription failed. Try the fixture again.'),
      findsOneWidget,
    );
    expect(find.textContaining('transcription unavailable'), findsNothing);
    expect(find.textContaining('Session failed'), findsOneWidget);
    expect(find.text('No source caption yet.'), findsOneWidget);
    expect(find.text('No translated caption yet.'), findsOneWidget);
  });

  testWidgets('surfaces injected audio capture service errors', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FixtureCaptionPage(
          audioCaptureService: _FailingAudioCaptureService(),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text(
        'Audio capture failed. Fixture mode did not record or send audio.',
      ),
      300,
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Audio capture failed. Fixture mode did not record or send audio.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('audio capture unavailable'), findsNothing);
    expect(find.textContaining('Session failed'), findsOneWidget);
    expect(find.text('No source caption yet.'), findsOneWidget);
    expect(find.text('No translated caption yet.'), findsOneWidget);
  });
}

void _setTestViewSize(WidgetTester tester, Size size) {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = size;
  addTearDown(() {
    tester.view
      ..resetDevicePixelRatio()
      ..resetPhysicalSize();
  });
}

Finder _languageDropdownField(String key) {
  return find.descendant(
    of: find.byKey(Key(key)),
    matching: find.byType(DropdownButtonFormField<BabelLanguage>),
  );
}

final class _FailingAudioCaptureService implements AudioCaptureService {
  const _FailingAudioCaptureService();

  @override
  Stream<List<int>> capture({
    required SpeechSession session,
    AudioCaptureConfig config = const AudioCaptureConfig(),
  }) {
    return Stream.error(StateError('audio capture unavailable'));
  }
}

final class _FailingTranscriptionService implements TranscriptionService {
  const _FailingTranscriptionService();

  @override
  Stream<TranscriptSegment> transcribe({
    required SpeechSession session,
    required Stream<List<int>> audioBytes,
  }) async* {
    throw StateError('transcription unavailable');
  }
}

final class _DeferredTranslationService implements TranslationService {
  final _completer = Completer<TranslationResult>();
  TranscriptSegment? segment;
  BabelLanguage? targetLanguage;

  @override
  Future<TranslationResult> translate({
    required TranscriptSegment segment,
    required BabelLanguage targetLanguage,
  }) {
    this.segment = segment;
    this.targetLanguage = targetLanguage;
    return _completer.future;
  }

  void complete(TranslationResult result) {
    _completer.complete(result);
  }
}

final class _FailsOnceTranslationService implements TranslationService {
  final _delegate = const FixtureTranslationService();
  var _calls = 0;

  @override
  Future<TranslationResult> translate({
    required TranscriptSegment segment,
    required BabelLanguage targetLanguage,
  }) {
    _calls += 1;
    if (_calls == 1) {
      throw StateError('temporary translation outage');
    }

    return _delegate.translate(
      segment: segment,
      targetLanguage: targetLanguage,
    );
  }
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
