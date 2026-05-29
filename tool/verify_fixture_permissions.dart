import 'dart:io';

void main() {
  final violations = <String>[];

  for (final check in _permissionChecks) {
    final file = File(check.path);
    if (!file.existsSync()) {
      continue;
    }

    final contents = file.readAsStringSync();
    for (final token in check.forbiddenTokens) {
      if (contents.contains(token)) {
        violations.add('${check.path}: $token');
      }
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('Fixture mode platform permission check passed.');
    return;
  }

  stderr.writeln(
    'Fixture mode must not request microphone permissions. '
    'Found forbidden platform permission tokens:',
  );
  for (final violation in violations) {
    stderr.writeln('- $violation');
  }

  exitCode = 1;
}

const _permissionChecks = [
  _PermissionCheck(
    path: 'app/android/app/src/main/AndroidManifest.xml',
    forbiddenTokens: [
      'android.permission.RECORD_AUDIO',
      'android.permission.CAPTURE_AUDIO_OUTPUT',
    ],
  ),
  _PermissionCheck(
    path: 'app/android/app/src/debug/AndroidManifest.xml',
    forbiddenTokens: [
      'android.permission.RECORD_AUDIO',
      'android.permission.CAPTURE_AUDIO_OUTPUT',
    ],
  ),
  _PermissionCheck(
    path: 'app/android/app/src/profile/AndroidManifest.xml',
    forbiddenTokens: [
      'android.permission.RECORD_AUDIO',
      'android.permission.CAPTURE_AUDIO_OUTPUT',
    ],
  ),
  _PermissionCheck(
    path: 'app/ios/Runner/Info.plist',
    forbiddenTokens: ['NSMicrophoneUsageDescription'],
  ),
  _PermissionCheck(
    path: 'app/macos/Runner/DebugProfile.entitlements',
    forbiddenTokens: ['com.apple.security.device.audio-input'],
  ),
  _PermissionCheck(
    path: 'app/macos/Runner/Release.entitlements',
    forbiddenTokens: ['com.apple.security.device.audio-input'],
  ),
  _PermissionCheck(
    path: 'app/web/index.html',
    forbiddenTokens: ['getUserMedia'],
  ),
  _PermissionCheck(
    path: 'app/web/manifest.json',
    forbiddenTokens: ['getUserMedia'],
  ),
];

final class _PermissionCheck {
  const _PermissionCheck({required this.path, required this.forbiddenTokens});

  final String path;
  final List<String> forbiddenTokens;
}
