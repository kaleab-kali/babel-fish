import 'package:babelfish_core/babelfish_core.dart';
import 'package:test/test.dart';

void main() {
  group('LatencyMeasurement', () {
    test('returns null for incomplete timing checkpoints', () {
      final measurement = LatencyMeasurement(
        captureStartedAt: DateTime.utc(2026, 1, 1),
      );

      expect(measurement.transcriptionLatency, isNull);
      expect(measurement.translationLatency, isNull);
      expect(measurement.renderLatency, isNull);
      expect(measurement.perceivedLatency, isNull);
    });

    test('calculates each latency stage', () {
      final startedAt = DateTime.utc(2026, 1, 1);
      final measurement = LatencyMeasurement(
        captureStartedAt: startedAt,
        transcriptAvailableAt: startedAt.add(const Duration(milliseconds: 80)),
        translationAvailableAt: startedAt.add(
          const Duration(milliseconds: 140),
        ),
        captionRenderedAt: startedAt.add(const Duration(milliseconds: 170)),
      );

      expect(
        measurement.transcriptionLatency,
        const Duration(milliseconds: 80),
      );
      expect(measurement.translationLatency, const Duration(milliseconds: 60));
      expect(measurement.renderLatency, const Duration(milliseconds: 30));
      expect(measurement.perceivedLatency, const Duration(milliseconds: 170));
    });
  });
}
