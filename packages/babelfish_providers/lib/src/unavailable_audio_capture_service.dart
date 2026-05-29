import 'package:babelfish_core/babelfish_core.dart';

import 'provider_adapter_info.dart';
import 'provider_unavailable_exception.dart';

final class UnavailableAudioCaptureService implements AudioCaptureService {
  const UnavailableAudioCaptureService({
    required this.provider,
    this.reason = 'No live audio capture provider is configured.',
  });

  final ProviderAdapterInfo provider;
  final String reason;

  @override
  Stream<List<int>> capture({
    required SpeechSession session,
    AudioCaptureConfig config = const AudioCaptureConfig(),
  }) {
    throw ProviderUnavailableException(providerId: provider.id, reason: reason);
  }
}
