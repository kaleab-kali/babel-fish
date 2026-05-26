import 'package:babelfish_core/babelfish_core.dart';
import 'package:babelfish_fixtures/babelfish_fixtures.dart';
import 'package:test/test.dart';

void main() {
  group('FixtureTranscriptionService', () {
    test('emits transcript segments for the session source language', () async {
      const service = FixtureTranscriptionService();
      final session = SpeechSession(
        id: 'fixture-session',
        sourceLanguage: FixtureLanguages.english,
        targetLanguage: FixtureLanguages.amharic,
        startedAt: DateTime.utc(2026, 1, 1),
      );

      final segments = await service
          .transcribe(session: session, audioBytes: Stream<List<int>>.empty())
          .toList();

      expect(segments, hasLength(2));
      expect(segments.map((segment) => segment.language).toSet(), {
        FixtureLanguages.english,
      });
    });
  });
}
