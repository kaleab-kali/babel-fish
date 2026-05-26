# babelfish_providers

Provider adapter package for Babel Fish.

This package is intentionally small for now. It contains scaffolding for live transcription and translation adapters, but it does not ship fake live-provider behavior or require API keys.

## Current contents

- Provider adapter metadata.
- Explicit unavailable transcription and translation service implementations.
- Provider exceptions that callers can surface as clear app states.

Real provider adapters will be added after the fixture path is stable and privacy behavior is documented.
