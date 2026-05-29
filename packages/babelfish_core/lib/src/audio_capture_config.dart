enum AudioEncoding { pcm16, opus }

final class AudioCaptureConfig {
  const AudioCaptureConfig({
    this.sampleRateHertz = 16000,
    this.channelCount = 1,
    this.encoding = AudioEncoding.pcm16,
  }) : assert(sampleRateHertz > 0, 'sampleRateHertz must be positive'),
       assert(channelCount > 0, 'channelCount must be positive');

  final int sampleRateHertz;
  final int channelCount;
  final AudioEncoding encoding;

  bool get isMono {
    return channelCount == 1;
  }

  @override
  bool operator ==(Object other) {
    return other is AudioCaptureConfig &&
        other.sampleRateHertz == sampleRateHertz &&
        other.channelCount == channelCount &&
        other.encoding == encoding;
  }

  @override
  int get hashCode {
    return Object.hash(sampleRateHertz, channelCount, encoding);
  }
}
