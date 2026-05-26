# Babel Fish

Babel Fish is an open-source Flutter prototype for real-time speech translation. It is designed to capture speech, transcribe it, translate it, and show readable captions with clear latency reporting.

The project starts with deterministic fixture mode so contributors can build and test the experience without network access, paid provider accounts, or real user audio. Live transcription and translation providers will be added behind clean interfaces after the offline demo path is stable.

## Goals

- Provide a clean Flutter demo app for speech-to-caption translation.
- Keep the first demo fully reproducible with local fixtures.
- Separate app UI, core models, fixtures, and provider adapters.
- Measure perceived caption latency honestly.
- Document privacy, data retention, and provider behavior clearly.

## Current Status

Babel Fish is pre-release. The repository is being scaffolded for a runnable Flutter app and reusable Dart packages.

The first supported mode will be fixture mode:

- No network required.
- No API keys required.
- No real user audio required.
- Predictable transcript and translation data for demos and tests.

Live provider mode and on-device model support are planned after the core app flow is working.

## Planned Features

- Push-to-talk speech capture flow.
- Source and translated caption display.
- Language picker.
- Fixture-backed transcript and translation services.
- Transcript history.
- Copy translated text action.
- Latency overlay for capture, transcript, translation, and render timing.
- Provider adapter interfaces for future live transcription and translation.
- Privacy-first documentation for audio handling and third-party providers.

## Repository Layout

```text
babel-fish/
  app/                          # Flutter demo application
  packages/
    babelfish_core/             # Dart models and service interfaces
    babelfish_fixtures/         # Local demo transcripts and translations
    babelfish_providers/        # Live provider adapters, added later
  docs/                         # Demo notes, latency reports, privacy docs
```

## Architecture

The project is split into small packages so each part can be tested and reviewed independently.

`babelfish_core` will contain pure Dart models and contracts such as languages, transcript segments, translation results, speech sessions, latency measurements, transcription services, and translation services.

`babelfish_fixtures` will provide deterministic demo data and local service implementations.

`babelfish_providers` will contain optional live provider adapters. Provider credentials must be configured locally and must never be committed.

`app` will be the Flutter demo that connects the packages into a usable push-to-talk caption experience.

## Getting Started

The runnable Flutter scaffold is not committed yet. Once the first app scaffold lands, setup will look like this:

```sh
flutter pub get
flutter test
flutter run
```

Until then, the repository is focused on project structure, documentation, package boundaries, and open-source readiness.

## Privacy

Babel Fish is designed to make data behavior visible.

Fixture mode uses local demo text only. It should not send network requests, require microphone access, or store real user audio.

Recording mode and live provider mode will document what is captured, where temporary files are stored, what is sent to third-party services, and how users can disable or clear local data.

## Contributing

Contributions should be small, focused, and easy to review. The early project priority is a reliable fixture-backed demo before live provider integrations.

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## Security

Do not commit provider keys, real user recordings, private transcripts, or local environment files.

See [SECURITY.md](SECURITY.md) for vulnerability reporting and secret-handling guidance.

## License

Babel Fish is available under the [MIT License](LICENSE).
