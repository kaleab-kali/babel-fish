# babelfish_providers

Provider adapter package for Babel Fish.

This package is intentionally small for now. It contains scaffolding for live audio capture, transcription, and translation adapters, but it does not ship fake live-provider behavior or require API keys.

## Current contents

- Provider adapter metadata.
- Provider capability metadata for audio capture, transcription, and translation.
- Explicit unavailable audio capture, transcription, and translation service implementations.
- Provider exceptions that callers can surface as clear app states.

Real provider adapters will be added after the fixture path is stable and privacy behavior is documented.
