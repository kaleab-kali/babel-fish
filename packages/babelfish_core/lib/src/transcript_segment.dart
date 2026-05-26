import 'babel_language.dart';

final class TranscriptSegment {
  const TranscriptSegment({
    required this.id,
    required this.language,
    required this.text,
    required this.startOffset,
    required this.endOffset,
    this.confidence,
  });

  final String id;
  final BabelLanguage language;
  final String text;
  final Duration startOffset;
  final Duration endOffset;
  final double? confidence;

  Duration get duration => endOffset - startOffset;

  bool get hasConfidence => confidence != null;
}
