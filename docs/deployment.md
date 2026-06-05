# Deployment

Babel Fish can deploy the Flutter web fixture demo to GitHub Pages.

## Live demo

The current fixture demo is published at
[kaleab-kali.github.io/babel-fish](https://kaleab-kali.github.io/babel-fish/).

## GitHub Pages

The `Deploy Web` workflow builds the Flutter app from `app/`. Pull requests run build validation only. Pushes to `main` that touch the app, packages, the fixture offline verifier, the fixture permission verifier, the web metadata verifier, the web build budget verifier, or the deployment workflow run the build job.

Deployment is opt-in. Repository maintainers must configure GitHub Pages to use GitHub Actions as the source and set the repository Actions variable `BABEL_FISH_PAGES_DEPLOY` to `true`. After that variable is enabled, pushes to `main` configure GitHub Pages, upload `app/build/web` as a Pages artifact, and deploy it. The workflow can also be started manually with `workflow_dispatch` from `main`.

The workflow builds the app with `--base-href "/babel-fish/"` and `--dart-define=BABEL_FISH_MODE=fixture`, which matches the current repository name for project Pages URLs and keeps the published demo in the only supported runtime mode. After GitHub Pages publishes the artifact, the deploy job smoke-tests the live URL and fails if the published HTML does not contain the Babel Fish title and Flutter bootstrap script.

## Repository readiness checklist

Before enabling production Pages deployment:

- Confirm the `Dart Workspace`, `Flutter App`, and `Deploy Web` workflows pass on `main`.
- In repository settings, set Pages source to GitHub Actions.
- Add an Actions repository variable named `BABEL_FISH_PAGES_DEPLOY` with the value `true`.
- Run the `Deploy Web` workflow from `main` or push a reviewed app, package, tool, or deployment workflow change.
- Confirm the deployed Pages URL opens the fixture app without provider credentials, microphone permissions, real recordings, or private transcripts.

If the GitHub Pages API reports `404`, Pages has not been configured for the repository yet. If the Actions variables list is empty or does not include `BABEL_FISH_PAGES_DEPLOY=true`, deployment remains intentionally disabled even though build validation still runs.

## Pre-deploy checks

The deployment workflow runs:

```sh
dart tool/verify_fixture_permissions.dart
dart tool/verify_fixture_offline.dart
dart tool/verify_web_metadata.dart
cd app
flutter pub get
dart format --set-exit-if-changed .
dart analyze
flutter test
flutter build web --base-href "/babel-fish/" --dart-define=BABEL_FISH_MODE=fixture
cd ..
dart tool/verify_web_build_budget.dart
```

The web build budget currently limits `main.dart.js` to 3.0 MiB and the full
`app/build/web` artifact to 45.0 MiB. Raise those limits only with a clear
reason in the pull request.

Fixture mode must remain deployable without network calls from the app, provider credentials, microphone permissions, real recordings, or private transcripts.
