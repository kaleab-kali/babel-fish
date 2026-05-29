# Babel Fish App

Flutter app for the Babel Fish fixture caption flow.

The app currently supports fixture-backed language pair selection for English, French, and Amharic demo data. Translated captions can be copied from the demo flow, completed translations are shown in a clearable in-session history list, the current speech session status is visible, and the UI clearly marks the demo as offline fixture mode.

The app includes standard Flutter platform scaffolds for Android, iOS, Linux, macOS, web, and Windows. Flutter Web is the current runnable demo target; mobile and desktop folders are checked in early so microphone and speech-provider work can be added against a normal app scaffold.

Fixture mode should not request microphone permissions on any platform. Add platform microphone permissions only in the same reviewed change that introduces recording mode and documents the privacy behavior.

## Run

```sh
flutter pub get
flutter test
flutter run -d chrome
```
