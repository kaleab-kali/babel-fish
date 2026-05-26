import 'package:babelfish_core/babelfish_core.dart';
import 'package:babelfish_fixtures/babelfish_fixtures.dart';
import 'package:test/test.dart';

void main() {
  group('FixtureTranslationService', () {
    test('translates an English fixture segment to Amharic', () async {
      final completedAt = DateTime.utc(2026, 1, 1);
      final service = FixtureTranslationService(completedAt: completedAt);

      final result = await service.translate(
        segment: fixtureTranscriptSegments.first,
        targetLanguage: FixtureLanguages.amharic,
      );

      expect(result.text, 'ሰላም፣ ወደ Babel Fish እንኳን በደህና መጡ።');
      expect(result.provider, 'fixture');
      expect(result.completedAt, completedAt);
      expect(result.latency, Duration.zero);
    });

    test('throws when a fixture translation is missing', () async {
      const service = FixtureTranslationService();
      const segment = TranscriptSegment(
        id: 'unknown',
        language: FixtureLanguages.french,
        text: 'Unknown fixture text.',
        startOffset: Duration.zero,
        endOffset: Duration(milliseconds: 500),
      );

      expect(
        () => service.translate(
          segment: segment,
          targetLanguage: FixtureLanguages.amharic,
        ),
        throwsA(isA<FixtureTranslationNotFoundException>()),
      );
    });
  });
}
