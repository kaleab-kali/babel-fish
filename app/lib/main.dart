import 'package:babelfish_core/babelfish_core.dart';
import 'package:babelfish_fixtures/babelfish_fixtures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BabelFishApp());
}

class BabelFishApp extends StatelessWidget {
  const BabelFishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Babel Fish',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        useMaterial3: true,
      ),
      home: const FixtureCaptionPage(),
    );
  }
}

class FixtureCaptionPage extends StatefulWidget {
  const FixtureCaptionPage({super.key});

  @override
  State<FixtureCaptionPage> createState() => _FixtureCaptionPageState();
}

class _FixtureCaptionPageState extends State<FixtureCaptionPage> {
  final TranscriptionService _transcriptionService =
      const FixtureTranscriptionService();
  final TranslationService _translationService =
      const FixtureTranslationService();

  TranscriptSegment? _sourceSegment;
  TranslationResult? _translation;
  LatencyMeasurement? _latency;
  String? _error;
  bool _isPlaying = false;

  Future<void> _playFixture() async {
    final captureStartedAt = DateTime.now().toUtc();
    setState(() {
      _isPlaying = true;
      _sourceSegment = null;
      _translation = null;
      _error = null;
      _latency = LatencyMeasurement(captureStartedAt: captureStartedAt);
    });

    final session = SpeechSession(
      id: 'fixture-session',
      sourceLanguage: FixtureLanguages.english,
      targetLanguage: FixtureLanguages.amharic,
      startedAt: captureStartedAt,
      status: SpeechSessionStatus.listening,
    );

    try {
      final sourceSegment = await _transcriptionService
          .transcribe(session: session, audioBytes: Stream<List<int>>.empty())
          .first;
      final transcriptAvailableAt = DateTime.now().toUtc();

      final translation = await _translationService.translate(
        segment: sourceSegment,
        targetLanguage: FixtureLanguages.amharic,
      );
      final translationAvailableAt = DateTime.now().toUtc();

      if (!mounted) {
        return;
      }

      setState(() {
        _sourceSegment = sourceSegment;
        _translation = translation;
        _latency = LatencyMeasurement(
          captureStartedAt: captureStartedAt,
          transcriptAvailableAt: transcriptAvailableAt,
          translationAvailableAt: translationAvailableAt,
          captionRenderedAt: DateTime.now().toUtc(),
        );
        _isPlaying = false;
      });
    } on Object catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = error.toString();
        _isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Babel Fish'),
        backgroundColor: colorScheme.surface,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _LanguagePair(
              sourceLanguage: FixtureLanguages.english,
              targetLanguage: FixtureLanguages.amharic,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isPlaying ? null : _playFixture,
              icon: Icon(_isPlaying ? Icons.graphic_eq : Icons.mic),
              label: Text(_isPlaying ? 'Listening' : 'Play fixture'),
            ),
            const SizedBox(height: 20),
            _CaptionPanel(
              label: 'Source',
              text: _sourceSegment?.text ?? 'No source caption yet.',
            ),
            const SizedBox(height: 12),
            _CaptionPanel(
              label: 'Translation',
              text: _translation?.text ?? 'No translated caption yet.',
            ),
            const SizedBox(height: 20),
            _LatencyPanel(latency: _latency),
            if (_error != null) ...[
              const SizedBox(height: 20),
              Text(_error!, style: TextStyle(color: colorScheme.error)),
            ],
          ],
        ),
      ),
    );
  }
}

class _LanguagePair extends StatelessWidget {
  const _LanguagePair({
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  final BabelLanguage sourceLanguage;
  final BabelLanguage targetLanguage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _LanguageTile(
            label: 'Source',
            languageName: sourceLanguage.displayName,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Icon(Icons.arrow_forward),
        ),
        Expanded(
          child: _LanguageTile(
            label: 'Target',
            languageName: targetLanguage.displayName,
          ),
        ),
      ],
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.label, required this.languageName});

  final String label;
  final String languageName;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelMedium),
        const SizedBox(height: 4),
        Text(languageName, style: textTheme.titleMedium),
      ],
    );
  }
}

class _CaptionPanel extends StatelessWidget {
  const _CaptionPanel({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(text, style: textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

class _LatencyPanel extends StatelessWidget {
  const _LatencyPanel({required this.latency});

  final LatencyMeasurement? latency;

  @override
  Widget build(BuildContext context) {
    final measurement = latency;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _LatencyChip(
          label: 'Transcript',
          value: _formatDuration(measurement?.transcriptionLatency),
        ),
        _LatencyChip(
          label: 'Translation',
          value: _formatDuration(measurement?.translationLatency),
        ),
        _LatencyChip(
          label: 'Render',
          value: _formatDuration(measurement?.renderLatency),
        ),
        _LatencyChip(
          label: 'Perceived',
          value: _formatDuration(measurement?.perceivedLatency),
        ),
      ],
    );
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return '-- ms';
    }

    return '${duration.inMilliseconds} ms';
  }
}

class _LatencyChip extends StatelessWidget {
  const _LatencyChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.speed, size: 18),
      label: Text('$label $value'),
    );
  }
}
