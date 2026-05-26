import 'package:babelfish_core/babelfish_core.dart';

import 'provider_adapter_info.dart';
import 'provider_unavailable_exception.dart';

final class UnavailableTranslationService implements TranslationService {
  const UnavailableTranslationService({
    required this.provider,
    this.reason = 'No live translation provider is configured.',
  });

  final ProviderAdapterInfo provider;
  final String reason;

  @override
  Future<TranslationResult> translate({
    required TranscriptSegment segment,
    required BabelLanguage targetLanguage,
  }) async {
    throw ProviderUnavailableException(providerId: provider.id, reason: reason);
  }
}
