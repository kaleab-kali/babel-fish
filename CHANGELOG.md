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
- Added provider adapter catalog lookup and capability filtering.
- Made provider metadata validate identifiers and defensively copy capabilities.
- Added injectable caption services to the Flutter fixture page for future provider wiring.
- Added speech session lifecycle helpers for immutable status updates.
- Added visible speech session status to the Flutter fixture page.
- Added session duration to completed and failed Flutter fixture sessions.
- Added CI verification that fixture mode does not request platform microphone permissions.
- Added fixture transcript cycling for repeated Flutter demo runs.
- Added a GitHub Pages deployment workflow for the Flutter web fixture demo.
- Gated GitHub Pages deployment behind an explicit repository variable.
- Added CI verification for committed secrets, recordings, and private transcript artifacts.
- Added workflow concurrency, job timeouts, and current checkout actions for CI reliability.
- Restored proper Amharic and French fixture text for the multilingual demo.
- Added explicit screen-reader semantics for fixture status, captions, and latency readouts.
- Added CI verification for the Flutter web build size budget.
- Updated web workflow path filters to run when the build budget verifier changes.
- Corrected deployment check documentation for the web build budget verifier.
- Clarified Android application ID and release signing comments in the app scaffold.
- Aligned Flutter web viewport and PWA theme metadata with the app experience.
- Updated local workflow documentation for current security and web budget checks.
- Tightened contribution templates for privacy-sensitive speech and fixture-mode reports.
- Documented release readiness checks and artifact safety guidance.
- Added Dependabot update checks for GitHub Actions and Dart package manifests.
- Added CI verification for local Markdown links.
- Scoped Dependabot pub updates to the Dart workspace root and Flutter app.
- Added a Flutter fixture control for swapping supported language pairs.
- Removed the redundant Flutter web viewport meta tag to avoid runtime warnings.
- Added CI verification for Flutter web metadata and manifest assets.
- Corrected deployment documentation for the web metadata verifier trigger.
- Added CI verification that fixture app and fixture package code stay offline.
- Added CI verification for GitHub Actions workflow security guards.
- Added repository metadata to workspace and package manifests.
- Added Flutter widget coverage for responsive language controls.
- Added CI verification for pubspec repository metadata.
- Documented the Flutter platform scaffold regeneration command.
- Clarified GitHub Pages deployment readiness and troubleshooting guidance.
- Updated Flutter App workflow triggers for fixture permission verifier changes.
