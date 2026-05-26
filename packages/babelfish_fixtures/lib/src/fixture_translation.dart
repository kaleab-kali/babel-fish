import 'package:babelfish_core/babelfish_core.dart';

final class FixtureTranslation {
  const FixtureTranslation({
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.sourceText,
    required this.translatedText,
  });

  final BabelLanguage sourceLanguage;
  final BabelLanguage targetLanguage;
  final String sourceText;
  final String translatedText;

  bool matches({
    required TranscriptSegment segment,
    required BabelLanguage requestedTargetLanguage,
  }) {
    return sourceLanguage == segment.language &&
        targetLanguage == requestedTargetLanguage &&
        sourceText == segment.text;
  }
}
