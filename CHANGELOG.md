# Changelog

All notable changes to Babel Fish will be documented in this file.

The project follows a human-readable changelog. Versioning will be introduced once the first runnable demo is available.

## Unreleased

- Added open-source project foundation files.
- Added initial Dart workspace and `babelfish_core` package scaffold.
- Added `babelfish_fixtures` package with offline transcript and translation services.
- Added GitHub Actions checks for Dart formatting, analysis, and package tests.
- Added initial Flutter fixture caption demo app.
- Added GitHub Actions checks for the Flutter app.
- Added `babelfish_providers` package scaffold for future live adapters.
- Added fixture language-pair selection to the Flutter demo app.
- Added translated-caption copy support to the Flutter demo app.
- Added in-session caption history to the Flutter demo app.
- Added a visible offline fixture-mode status to the Flutter demo app.
- Updated the fixture demo script for the current Flutter app flow.
- Added the Flutter app dependency that provides the Cupertino icon font asset.
- Added Flutter web build verification to the app CI workflow.
- Regenerated the Flutter app scaffold with standard Android, iOS, Linux, macOS, web, and Windows platform folders.
- Added a clear action for the Flutter demo app's in-session caption history.
- Added platform-neutral audio capture contracts to `babelfish_core`.
- Added deterministic fixture audio capture service and wired the Flutter demo to use it.
- Added unavailable provider audio capture adapter scaffold.
- Added Android debug build verification to the Flutter app CI workflow.
- Documented the platform microphone permission boundary for fixture mode.
- Added provider capability metadata for future live adapter declarations.
