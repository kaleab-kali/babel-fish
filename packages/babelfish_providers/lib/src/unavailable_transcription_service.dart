import 'package:babelfish_core/babelfish_core.dart';

import 'provider_adapter_info.dart';
import 'provider_unavailable_exception.dart';

final class UnavailableTranscriptionService implements TranscriptionService {
  const UnavailableTranscriptionService({
    required this.provider,
    this.reason = 'No live transcription provider is configured.',
  });

  final ProviderAdapterInfo provider;
  final String reason;

  @override
  Stream<TranscriptSegment> transcribe({
    required SpeechSession session,
    required Stream<List<int>> audioBytes,
  }) {
    throw ProviderUnavailableException(providerId: provider.id, reason: reason);
  }
}
