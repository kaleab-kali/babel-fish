# Babel Fish App

Flutter app for the Babel Fish fixture caption flow.

The app currently supports fixture-backed language pair selection and supported-pair swapping for English, French, and Amharic demo data. Repeated fixture runs advance through available local transcript segments for the selected source language. Translated captions can be copied from the demo flow, completed translations are shown in a clearable in-session history list, the current speech session status and duration are visible, and the UI clearly marks the demo as offline fixture mode.

The app includes standard Flutter platform scaffolds for Android, iOS, Linux, macOS, web, and Windows. Flutter Web is the current runnable demo target; mobile and desktop folders are checked in early so microphone and speech-provider work can be added against a normal app scaffold.

Fixture mode should not request microphone permissions on any platform. Add platform microphone permissions only in the same reviewed change that introduces recording mode and documents the privacy behavior.

## Scaffold regeneration

Repair or refresh generated platform files with Flutter tooling instead of hand-writing scaffold boilerplate:

```sh
flutter create . --project-name babel_fish_app --org dev.babelfish --platforms android,ios,linux,macos,web,windows
```

After regenerating scaffold files, review the diff carefully and rerun the fixture permission, web metadata, Flutter test, web build, Android debug build, and web build budget checks from the repository docs.

## Run

```sh
flutter pub get
dart format --set-exit-if-changed .
dart analyze
flutter test
flutter build web
flutter run -d chrome
```
