import 'package:babelfish_core/babelfish_core.dart';

final class FixtureAudioCaptureService implements AudioCaptureService {
  const FixtureAudioCaptureService({
    this.chunks = const <List<int>>[
      <int>[0],
    ],
  });

  final Iterable<List<int>> chunks;

  @override
  Stream<List<int>> capture({
    required SpeechSession session,
    AudioCaptureConfig config = const AudioCaptureConfig(),
  }) {
    return Stream<List<int>>.fromIterable(chunks);
  }
}
