# babelfish_core

Core Dart models and service contracts for Babel Fish.

This package is intentionally platform-neutral. It does not depend on Flutter, provider SDKs, microphone APIs, or network clients.

## Contents

- Language metadata.
- Transcript segment model.
- Translation result model.
- Speech session model.
- Latency measurement model.
- Transcription and translation service contracts.

## Usage

```dart
import 'package:babelfish_core/babelfish_core.dart';

const english = BabelLanguage(code: 'en', name: 'English');
const french = BabelLanguage(code: 'fr', name: 'French', nativeName: 'Francais');

final session = SpeechSession(
  id: 'demo-session',
  sourceLanguage: english,
  targetLanguage: french,
  startedAt: DateTime.utc(2026, 1, 1),
);
```
