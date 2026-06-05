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
dart tool/verify_no_secrets.dart
dart tool/verify_fixture_offline.dart
dart tool/verify_markdown_links.dart
dart analyze
dart test packages/babelfish_core
dart test packages/babelfish_fixtures
dart test packages/babelfish_providers
```

Pull requests run the same Dart workspace checks in GitHub Actions.

For Flutter app work, run:

```sh
dart tool/verify_fixture_permissions.dart
dart tool/verify_fixture_offline.dart
dart tool/verify_web_metadata.dart
cd app
flutter pub get
dart format --set-exit-if-changed .
dart analyze
flutter test
flutter build web
flutter build apk --debug
cd ..
dart tool/verify_web_build_budget.dart
```

Flutter app changes also run app-specific GitHub Actions checks. The repository keeps generated Flutter platform scaffolds checked in; use Flutter tooling to repair or update those folders instead of hand-writing platform boilerplate.

The fixture permission verifier must keep passing until recording mode is introduced with reviewed platform permission and privacy documentation updates.

Maintainer release checks are documented in [docs/release.md](docs/release.md).

## Pull request checklist

- The change is small enough to review.
- Public APIs are documented.
- User-facing behavior is covered by tests or clear manual verification.
- README or docs are updated when setup, behavior, privacy, or limitations change.
- `dart tool/verify_no_secrets.dart` passes.
- `dart tool/verify_fixture_offline.dart` passes after fixture app or fixture package changes.
- `dart tool/verify_markdown_links.dart` passes after documentation changes.
- `dart tool/verify_web_metadata.dart` passes after Flutter web metadata changes.
- `dart tool/verify_web_build_budget.dart` passes after Flutter web builds.
- The branch contains no generated files, local recordings, credentials, or provider keys.
