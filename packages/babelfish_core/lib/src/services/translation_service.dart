import '../babel_language.dart';
import '../transcript_segment.dart';
import '../translation_result.dart';

abstract interface class TranslationService {
  Future<TranslationResult> translate({
    required TranscriptSegment segment,
    required BabelLanguage targetLanguage,
  });
}
