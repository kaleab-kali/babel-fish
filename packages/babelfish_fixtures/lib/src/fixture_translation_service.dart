import 'package:babelfish_core/babelfish_core.dart';

import 'fixture_translation.dart';
import 'fixture_translations.dart';

final class FixtureTranslationNotFoundException implements Exception {
  const FixtureTranslationNotFoundException({
    required this.sourceLanguageCode,
    required this.targetLanguageCode,
    required this.sourceText,
  });

  final String sourceLanguageCode;
  final String targetLanguageCode;
  final String sourceText;

  @override
  String toString() {
    return 'No fixture translation for $sourceLanguageCode to '
        '$targetLanguageCode: $sourceText';
  }
}

final class FixtureTranslationService implements TranslationService {
  const FixtureTranslationService({
    this.translations = fixtureTranslations,
    this.completedAt,
  });

  final List<FixtureTranslation> translations;
  final DateTime? completedAt;

  @override
  Future<TranslationResult> translate({
    required TranscriptSegment segment,
    required BabelLanguage targetLanguage,
  }) async {
    for (final translation in translations) {
      if (translation.matches(
        segment: segment,
        requestedTargetLanguage: targetLanguage,
      )) {
        return TranslationResult(
          sourceSegment: segment,
          targetLanguage: targetLanguage,
          text: translation.translatedText,
          completedAt: completedAt ?? DateTime.now().toUtc(),
          provider: 'fixture',
          latency: Duration.zero,
        );
      }
    }

    throw FixtureTranslationNotFoundException(
      sourceLanguageCode: segment.language.code,
      targetLanguageCode: targetLanguage.code,
      sourceText: segment.text,
    );
  }
}
