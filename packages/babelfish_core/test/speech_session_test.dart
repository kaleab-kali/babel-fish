import 'package:babelfish_core/babelfish_core.dart';
import 'package:test/test.dart';

void main() {
  group('SpeechSession', () {
    const english = BabelLanguage(code: 'en', name: 'English');
    const french = BabelLanguage(code: 'fr', name: 'French');
    final startedAt = DateTime.utc(2026, 1, 1, 12);

    test('reports active capture and processing states', () {
      for (final status in [
        SpeechSessionStatus.listening,
        SpeechSessionStatus.transcribing,
        SpeechSessionStatus.translating,
      ]) {
        final session = SpeechSession(
          id: status.name,
          sourceLanguage: english,
          targetLanguage: french,
          startedAt: startedAt,
          status: status,
        );

        expect(session.isActive, isTrue);
      }
    });

    test('reports inactive terminal and idle states', () {
      for (final status in [
        SpeechSessionStatus.idle,
        SpeechSessionStatus.paused,
        SpeechSessionStatus.completed,
        SpeechSessionStatus.failed,
      ]) {
        final session = SpeechSession(
          id: status.name,
          sourceLanguage: english,
          targetLanguage: french,
          startedAt: startedAt,
          status: status,
        );

        expect(session.isActive, isFalse);
      }
    });

    test('calculates duration only when the session has ended', () {
      final activeSession = SpeechSession(
        id: 'active',
        sourceLanguage: english,
        targetLanguage: french,
        startedAt: startedAt,
        status: SpeechSessionStatus.listening,
      );
      final completedSession = activeSession.copyWith(
        endedAt: startedAt.add(const Duration(seconds: 3)),
        status: SpeechSessionStatus.completed,
      );

      expect(activeSession.duration, isNull);
      expect(completedSession.duration, const Duration(seconds: 3));
    });

    test('copies lifecycle fields without mutating the original session', () {
      final session = SpeechSession(
        id: 'session',
        sourceLanguage: english,
        targetLanguage: french,
        startedAt: startedAt,
      );
      final updated = session.copyWith(
        id: 'updated',
        status: SpeechSessionStatus.translating,
      );

      expect(session.id, 'session');
      expect(session.status, SpeechSessionStatus.idle);
      expect(updated.id, 'updated');
      expect(updated.sourceLanguage, english);
      expect(updated.targetLanguage, french);
      expect(updated.status, SpeechSessionStatus.translating);
    });

    test('can clear an ended timestamp when resuming a session', () {
      final completedSession = SpeechSession(
        id: 'session',
        sourceLanguage: english,
        targetLanguage: french,
        startedAt: startedAt,
        endedAt: startedAt.add(const Duration(seconds: 1)),
        status: SpeechSessionStatus.completed,
      );
      final resumedSession = completedSession.copyWith(
        clearEndedAt: true,
        status: SpeechSessionStatus.listening,
      );

      expect(completedSession.duration, const Duration(seconds: 1));
      expect(resumedSession.endedAt, isNull);
      expect(resumedSession.duration, isNull);
      expect(resumedSession.isActive, isTrue);
    });
  });
}
