# Deployment

Babel Fish can deploy the Flutter web fixture demo to GitHub Pages.

## GitHub Pages

The `Deploy Web` workflow builds the Flutter app from `app/`. Pull requests run build validation only. Pushes to `main` that touch the app, packages, the fixture permission verifier, the web build budget verifier, or the deployment workflow run the build job.

Deployment is opt-in. Repository maintainers must configure GitHub Pages to use GitHub Actions as the source and set the repository Actions variable `BABEL_FISH_PAGES_DEPLOY` to `true`. After that variable is enabled, pushes to `main` configure GitHub Pages, upload `app/build/web` as a Pages artifact, and deploy it. The workflow can also be started manually with `workflow_dispatch` from `main`.

The workflow builds the app with `--base-href "/babel-fish/"`, which matches the current repository name for project Pages URLs.

## Pre-deploy checks

The deployment workflow runs:

```sh
dart tool/verify_fixture_permissions.dart
dart tool/verify_web_metadata.dart
cd app
flutter pub get
dart format --set-exit-if-changed .
dart analyze
flutter test
flutter build web --base-href "/babel-fish/"
cd ..
dart tool/verify_web_build_budget.dart
```

The web build budget currently limits `main.dart.js` to 3.0 MiB and the full
`app/build/web` artifact to 45.0 MiB. Raise those limits only with a clear
reason in the pull request.

Fixture mode must remain deployable without network calls from the app, provider credentials, microphone permissions, real recordings, or private transcripts.
