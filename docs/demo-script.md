# Demo Script

This document tracks the repeatable fixture demo for contributors, reviewers,
and portfolio walkthroughs.

## Fixture demo

1. Launch the Flutter app with `flutter run -d chrome --dart-define=BABEL_FISH_MODE=fixture` from `app/`.
2. Confirm the banner shows `Fixture mode` and the offline demo-data status.
3. Select a source and target language pair.
4. Press `Play fixture`.
5. Confirm the source caption and translated caption are rendered.
6. Confirm latency chips are shown for transcript, translation, render, and perceived latency.
7. Copy the translated text.
8. Run another fixture language pair and confirm the next available fixture segment appears in history.
9. Clear the history and confirm the current captions remain visible.

Initial fixture language pairs:

- English to Amharic.
- English to French.
- Amharic to English.

Expected fixture behavior:

- No network access is required.
- No API keys are required.
- No microphone input or real user audio is required.
- Captions and translations come from deterministic local fixtures.

## Live provider demo

Live provider mode is planned after fixture mode is stable.
