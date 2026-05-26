import '../speech_session.dart';
import '../transcript_segment.dart';

abstract interface class TranscriptionService {
  Stream<TranscriptSegment> transcribe({
    required SpeechSession session,
    required Stream<List<int>> audioBytes,
  });
}
