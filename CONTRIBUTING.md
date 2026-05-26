# Contributing

Thanks for helping improve Babel Fish.

The project is early and intentionally fixture-first. Contributions should keep the demo honest, deterministic, and easy to run without network access.

## Development principles

- Prefer small pull requests with one clear purpose.
- Keep fixture mode working without API keys.
- Do not commit secrets, recordings from real users, or private data.
- Add tests for core models, fixtures, and provider contracts.
- Document limitations instead of overstating capability.

## Local workflow

Fetch dependencies:

```sh
dart pub get
```

For current Dart package work, run:

```sh
dart format --set-exit-if-changed .
dart analyze
dart test packages/babelfish_core
```

When the Flutter app exists, app checks will include:

```sh
flutter pub get
flutter analyze
flutter test
```

## Pull request checklist

- The change is small enough to review.
- Public APIs are documented.
- User-facing behavior is covered by tests or clear manual verification.
- README or docs are updated when setup, behavior, privacy, or limitations change.
- The branch contains no generated files, local recordings, credentials, or provider keys.
