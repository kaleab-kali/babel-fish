import 'package:babelfish_core/babelfish_core.dart';

import 'fixture_transcripts.dart';

final class FixtureTranscriptionService implements TranscriptionService {
  const FixtureTranscriptionService({
    this.segments = fixtureTranscriptSegments,
  });

  final List<TranscriptSegment> segments;

  @override
  Stream<TranscriptSegment> transcribe({
    required SpeechSession session,
    required Stream<List<int>> audioBytes,
  }) async* {
    await audioBytes.drain<void>();

    for (final segment in segments) {
      if (segment.language == session.sourceLanguage) {
        yield segment;
      }
    }
  }
}
