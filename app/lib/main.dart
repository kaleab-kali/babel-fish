import 'package:babelfish_core/babelfish_core.dart';
import 'package:babelfish_fixtures/babelfish_fixtures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  late BabelLanguage _sourceLanguage;
  late BabelLanguage _targetLanguage;
  TranscriptSegment? _sourceSegment;
  TranslationResult? _translation;
  LatencyMeasurement? _latency;
  String? _error;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _sourceLanguage = _sourceLanguageOptions.first;
    _targetLanguage = _targetLanguagesFor(_sourceLanguage).first;
  }

  List<BabelLanguage> get _sourceLanguageOptions {
    return _uniqueLanguages(
      fixtureTranslations.map((translation) => translation.sourceLanguage),
    );
  }

  List<BabelLanguage> get _targetLanguageOptions {
    return _targetLanguagesFor(_sourceLanguage);
  }

  List<BabelLanguage> _targetLanguagesFor(BabelLanguage sourceLanguage) {
    return _uniqueLanguages(
      fixtureTranslations
          .where((translation) => translation.sourceLanguage == sourceLanguage)
          .map((translation) => translation.targetLanguage),
    );
  }

  List<BabelLanguage> _uniqueLanguages(Iterable<BabelLanguage> languages) {
    return languages.toSet().toList(growable: false);
  }

  void _selectSourceLanguage(BabelLanguage? language) {
    if (language == null || language == _sourceLanguage) {
      return;
    }

    final targets = _targetLanguagesFor(language);
    setState(() {
      _sourceLanguage = language;
      _targetLanguage = targets.first;
      _clearCaptionState();
    });
  }

  void _selectTargetLanguage(BabelLanguage? language) {
    if (language == null || language == _targetLanguage) {
      return;
    }

    setState(() {
      _targetLanguage = language;
      _clearCaptionState();
    });
  }

  void _clearCaptionState() {
    _sourceSegment = null;
    _translation = null;
    _latency = null;
    _error = null;
  }

  Future<void> _copyTranslation() async {
    final translation = _translation;
    if (translation == null) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: translation.text));

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied translation')));
  }

  Future<void> _playFixture() async {
    final captureStartedAt = DateTime.now().toUtc();
    setState(() {
      _isPlaying = true;
      _clearCaptionState();
      _latency = LatencyMeasurement(captureStartedAt: captureStartedAt);
    });

    final session = SpeechSession(
      id: 'fixture-session',
      sourceLanguage: _sourceLanguage,
      targetLanguage: _targetLanguage,
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
        targetLanguage: _targetLanguage,
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
            _LanguageSelector(
              sourceLanguage: _sourceLanguage,
              targetLanguage: _targetLanguage,
              sourceLanguages: _sourceLanguageOptions,
              targetLanguages: _targetLanguageOptions,
              onSourceChanged: _isPlaying ? null : _selectSourceLanguage,
              onTargetChanged: _isPlaying ? null : _selectTargetLanguage,
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
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                key: const Key('copy-translation-button'),
                onPressed: _translation == null ? null : _copyTranslation,
                icon: const Icon(Icons.copy),
                label: const Text('Copy translation'),
              ),
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

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.sourceLanguages,
    required this.targetLanguages,
    required this.onSourceChanged,
    required this.onTargetChanged,
  });

  final BabelLanguage sourceLanguage;
  final BabelLanguage targetLanguage;
  final List<BabelLanguage> sourceLanguages;
  final List<BabelLanguage> targetLanguages;
  final ValueChanged<BabelLanguage?>? onSourceChanged;
  final ValueChanged<BabelLanguage?>? onTargetChanged;

  @override
  Widget build(BuildContext context) {
    final sourceDropdown = _LanguageDropdown(
      key: const Key('source-language-dropdown'),
      label: 'Source',
      value: sourceLanguage,
      languages: sourceLanguages,
      onChanged: onSourceChanged,
    );
    final targetDropdown = _LanguageDropdown(
      key: const Key('target-language-dropdown'),
      label: 'Target',
      value: targetLanguage,
      languages: targetLanguages,
      onChanged: onTargetChanged,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 520) {
          return Column(
            children: [
              sourceDropdown,
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Icon(Icons.arrow_downward),
              ),
              targetDropdown,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: sourceDropdown),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.arrow_forward),
            ),
            Expanded(child: targetDropdown),
          ],
        );
      },
    );
  }
}

class _LanguageDropdown extends StatelessWidget {
  const _LanguageDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.languages,
    required this.onChanged,
  });

  final String label;
  final BabelLanguage value;
  final List<BabelLanguage> languages;
  final ValueChanged<BabelLanguage?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<BabelLanguage>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final language in languages)
          DropdownMenuItem(value: language, child: Text(language.displayName)),
      ],
      onChanged: onChanged,
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
