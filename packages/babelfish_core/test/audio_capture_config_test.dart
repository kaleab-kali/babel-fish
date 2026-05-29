import 'package:babelfish_core/babelfish_core.dart';
import 'package:test/test.dart';

void main() {
  group('AudioCaptureConfig', () {
    test('defaults to mono PCM speech capture settings', () {
      const config = AudioCaptureConfig();

      expect(config.sampleRateHertz, 16000);
      expect(config.channelCount, 1);
      expect(config.encoding, AudioEncoding.pcm16);
      expect(config.isMono, isTrue);
    });

    test('reports non-mono channel layouts', () {
      const config = AudioCaptureConfig(channelCount: 2);

      expect(config.isMono, isFalse);
    });

    test('has value equality', () {
      const first = AudioCaptureConfig(
        sampleRateHertz: 48000,
        channelCount: 2,
        encoding: AudioEncoding.opus,
      );
      const second = AudioCaptureConfig(
        sampleRateHertz: 48000,
        channelCount: 2,
        encoding: AudioEncoding.opus,
      );

      expect(first, second);
      expect(first.hashCode, second.hashCode);
    });
  });
}
