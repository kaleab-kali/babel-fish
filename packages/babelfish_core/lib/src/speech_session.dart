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

  SpeechSession copyWith({
    String? id,
    BabelLanguage? sourceLanguage,
    BabelLanguage? targetLanguage,
    DateTime? startedAt,
    DateTime? endedAt,
    bool clearEndedAt = false,
    SpeechSessionStatus? status,
  }) {
    return SpeechSession(
      id: id ?? this.id,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      startedAt: startedAt ?? this.startedAt,
      endedAt: clearEndedAt ? null : endedAt ?? this.endedAt,
      status: status ?? this.status,
    );
  }

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
