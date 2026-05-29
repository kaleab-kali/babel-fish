import 'package:babelfish_core/babelfish_core.dart';
import 'package:babelfish_providers/babelfish_providers.dart';
import 'package:test/test.dart';

void main() {
  const provider = ProviderAdapterInfo(
    id: 'live-demo',
    name: 'Live Demo',
    requiresNetwork: true,
    requiresCredentials: true,
    capabilities: <ProviderCapability>{
      ProviderCapability.audioCapture,
      ProviderCapability.transcription,
      ProviderCapability.translation,
    },
  );

  const english = BabelLanguage(code: 'en', name: 'English');
  const french = BabelLanguage(code: 'fr', name: 'French');

  group('UnavailableAudioCaptureService', () {
    test('throws an explicit provider exception', () {
      const service = UnavailableAudioCaptureService(provider: provider);
      final session = SpeechSession(
        id: 'session',
        sourceLanguage: english,
        targetLanguage: french,
        startedAt: DateTime.utc(2026, 1, 1),
      );

      expect(
        () => service.capture(
          session: session,
          config: const AudioCaptureConfig(),
        ),
        throwsA(isA<ProviderUnavailableException>()),
      );
    });
  });

  group('UnavailableTranscriptionService', () {
    test('throws an explicit provider exception', () {
      const service = UnavailableTranscriptionService(provider: provider);
      final session = SpeechSession(
        id: 'session',
        sourceLanguage: english,
        targetLanguage: french,
        startedAt: DateTime.utc(2026, 1, 1),
      );

      expect(
        () => service.transcribe(
          session: session,
          audioBytes: Stream<List<int>>.empty(),
        ),
        throwsA(isA<ProviderUnavailableException>()),
      );
    });
  });

  group('UnavailableTranslationService', () {
    test('throws an explicit provider exception', () {
      const service = UnavailableTranslationService(provider: provider);
      const segment = TranscriptSegment(
        id: 'segment',
        language: english,
        text: 'Hello',
        startOffset: Duration.zero,
        endOffset: Duration(milliseconds: 400),
      );

      expect(
        () => service.translate(segment: segment, targetLanguage: french),
        throwsA(isA<ProviderUnavailableException>()),
      );
    });
  });
}
