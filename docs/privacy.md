# Privacy Notes

Babel Fish should be safe to demo and clear about data handling.

## Fixture mode

Fixture mode uses local demo text only. It does not require network access, microphone input, or provider credentials.

The checked-in Flutter platform scaffolds should not request microphone permissions while fixture mode is the only runnable app mode. Android, iOS, macOS, Windows, Linux, and web builds must keep using deterministic fixture capture until recording mode is introduced intentionally.

Run `dart tool/verify_fixture_permissions.dart` from the repository root before pull requests that touch app platform files. The same check runs in the Flutter app GitHub Actions workflow.

## Recording mode

Recording mode is planned. Before it is enabled, the app should clearly show when audio is captured and where temporary clips are stored. The pull request that enables recording mode must document each new platform permission, why it is needed, and whether captured audio stays local or is sent to a provider.

## Live provider mode

Live provider mode is planned. Provider adapters must document what data is sent to third parties and how credentials are configured.
