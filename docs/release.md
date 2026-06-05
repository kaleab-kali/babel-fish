# Release Process

Babel Fish is pre-release. Until the first versioned release exists, release
work should keep `main` healthy, reproducible, and free of private artifacts.

## Release Readiness

Before tagging a release candidate:

- Confirm all GitHub Actions checks on `main` are passing.
- Run the Dart workspace checks from the repository root.
- Run the Flutter app checks from `app/` when app behavior, generated platform
  scaffolds, or deployment output changed.
- Confirm generated platform scaffold changes came from Flutter tooling, not
  hand-written boilerplate.
- Verify fixture mode still runs without network access, API keys, microphone
  permissions, real recordings, or private transcripts.
- Confirm `CHANGELOG.md` describes contributor-visible changes.
- Review `README.md`, `CONTRIBUTING.md`, `SECURITY.md`, and `docs/privacy.md`
  for behavior, privacy, or setup changes.

## Local Verification

For Dart package changes:

```sh
dart pub get
dart format --set-exit-if-changed .
dart tool/verify_no_secrets.dart
dart tool/verify_workflow_security.dart
dart tool/verify_pubspec_metadata.dart
dart tool/verify_fixture_offline.dart
dart analyze
dart test packages/babelfish_core
dart test packages/babelfish_fixtures
dart test packages/babelfish_providers
```

For Flutter app changes:

```sh
dart tool/verify_fixture_permissions.dart
dart tool/verify_fixture_offline.dart
dart tool/verify_web_metadata.dart
cd app
flutter pub get
dart format --set-exit-if-changed .
dart analyze
flutter test
flutter build web --base-href "/babel-fish/"
flutter build apk --debug
cd ..
dart tool/verify_web_build_budget.dart
```

## Version Tags

Use semantic version tags once versioned releases begin.

```sh
git tag v0.1.0
git push origin v0.1.0
```

Create GitHub releases from tags after checks are green. Release notes should
summarize user-visible changes, contributor-facing changes, known limitations,
and privacy-sensitive behavior.

## Release Artifacts

Do not attach provider credentials, environment files, recordings, private
transcripts, or local build caches to releases.

The GitHub Pages deployment workflow publishes the Flutter web fixture artifact
only when maintainers explicitly enable the `BABEL_FISH_PAGES_DEPLOY`
repository variable.
