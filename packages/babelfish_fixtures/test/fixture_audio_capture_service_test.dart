import 'package:babelfish_core/babelfish_core.dart';
import 'package:babelfish_fixtures/babelfish_fixtures.dart';
import 'package:test/test.dart';

void main() {
  group('FixtureAudioCaptureService', () {
    test('emits deterministic local audio chunks', () async {
      const service = FixtureAudioCaptureService(
        chunks: <List<int>>[
          <int>[1, 2],
          <int>[3],
        ],
      );
      final session = SpeechSession(
        id: 'fixture-session',
        sourceLanguage: FixtureLanguages.english,
        targetLanguage: FixtureLanguages.amharic,
        startedAt: DateTime.utc(2026, 1, 1),
      );

      final chunks = await service
          .capture(session: session, config: const AudioCaptureConfig())
          .toList();

      expect(chunks, [
        [1, 2],
        [3],
      ]);
    });
  });
}
