import '../audio_capture_config.dart';
import '../speech_session.dart';

abstract interface class AudioCaptureService {
  Stream<List<int>> capture({
    required SpeechSession session,
    AudioCaptureConfig config = const AudioCaptureConfig(),
  });
}
