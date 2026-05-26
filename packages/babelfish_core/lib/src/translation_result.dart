import 'babel_language.dart';
import 'transcript_segment.dart';

final class TranslationResult {
  const TranslationResult({
    required this.sourceSegment,
    required this.targetLanguage,
    required this.text,
    required this.completedAt,
    this.provider,
    this.latency,
  });

  final TranscriptSegment sourceSegment;
  final BabelLanguage targetLanguage;
  final String text;
  final DateTime completedAt;
  final String? provider;
  final Duration? latency;
}
