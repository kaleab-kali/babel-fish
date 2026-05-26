final class LatencyMeasurement {
  const LatencyMeasurement({
    required this.captureStartedAt,
    this.transcriptAvailableAt,
    this.translationAvailableAt,
    this.captionRenderedAt,
  });

  final DateTime captureStartedAt;
  final DateTime? transcriptAvailableAt;
  final DateTime? translationAvailableAt;
  final DateTime? captionRenderedAt;

  Duration? get transcriptionLatency {
    final transcriptTime = transcriptAvailableAt;
    if (transcriptTime == null) {
      return null;
    }

    return transcriptTime.difference(captureStartedAt);
  }

  Duration? get translationLatency {
    final transcriptTime = transcriptAvailableAt;
    final translationTime = translationAvailableAt;
    if (transcriptTime == null || translationTime == null) {
      return null;
    }

    return translationTime.difference(transcriptTime);
  }

  Duration? get renderLatency {
    final translationTime = translationAvailableAt;
    final renderTime = captionRenderedAt;
    if (translationTime == null || renderTime == null) {
      return null;
    }

    return renderTime.difference(translationTime);
  }

  Duration? get perceivedLatency {
    final renderTime = captionRenderedAt;
    if (renderTime == null) {
      return null;
    }

    return renderTime.difference(captureStartedAt);
  }
}
