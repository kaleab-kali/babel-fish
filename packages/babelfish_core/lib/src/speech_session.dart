import 'babel_language.dart';

enum SpeechSessionStatus {
  idle,
  listening,
  transcribing,
  translating,
  paused,
  completed,
  failed,
}

final class SpeechSession {
  const SpeechSession({
    required this.id,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.startedAt,
    this.endedAt,
    this.status = SpeechSessionStatus.idle,
  });

  final String id;
  final BabelLanguage sourceLanguage;
  final BabelLanguage targetLanguage;
  final DateTime startedAt;
  final DateTime? endedAt;
  final SpeechSessionStatus status;

  bool get isActive {
    return switch (status) {
      SpeechSessionStatus.listening ||
      SpeechSessionStatus.transcribing ||
      SpeechSessionStatus.translating => true,
      SpeechSessionStatus.idle ||
      SpeechSessionStatus.paused ||
      SpeechSessionStatus.completed ||
      SpeechSessionStatus.failed => false,
    };
  }

  Duration? get duration {
    final end = endedAt;
    if (end == null) {
      return null;
    }

    return end.difference(startedAt);
  }
}
