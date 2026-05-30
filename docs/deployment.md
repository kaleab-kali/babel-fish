# Deployment

Babel Fish can deploy the Flutter web fixture demo to GitHub Pages.

## GitHub Pages

The `Deploy Web` workflow builds the Flutter app from `app/` and uploads `app/build/web` as a GitHub Pages artifact. Pull requests run the build job only. Pushes to `main` that touch the app, packages, the fixture permission verifier, or the deployment workflow run the build job and then deploy to GitHub Pages. The workflow can also be started manually with `workflow_dispatch` from `main`.

Repository maintainers must configure GitHub Pages to use GitHub Actions as the source before the first deployment. The workflow builds the app with `--base-href "/babel-fish/"`, which matches the current repository name for project Pages URLs.

## Pre-deploy checks

The deployment workflow runs:

```sh
dart tool/verify_fixture_permissions.dart
cd app
flutter pub get
dart format --set-exit-if-changed .
dart analyze
flutter test
flutter build web --base-href "/babel-fish/"
```

Fixture mode must remain deployable without network calls from the app, provider credentials, microphone permissions, real recordings, or private transcripts.
