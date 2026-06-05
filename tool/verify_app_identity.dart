import 'dart:io';

void main() {
  final violations = <String>[];

  for (final check in _identityChecks) {
    final file = File(check.path);
    if (!file.existsSync()) {
      violations.add('${check.path}: file is missing.');
      continue;
    }

    final contents = file.readAsStringSync();
    for (final expected in check.expectedTokens) {
      if (!contents.contains(expected)) {
        violations.add('${check.path}: missing $expected');
      }
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('App identity check passed.');
    return;
  }

  stderr.writeln('Platform app identity must stay aligned with Babel Fish:');
  for (final violation in violations) {
    stderr.writeln('- $violation');
  }

  exitCode = 1;
}

const _identityChecks = [
  _IdentityCheck(
    path: 'app/android/app/src/main/AndroidManifest.xml',
    expectedTokens: ['android:label="Babel Fish"'],
  ),
  _IdentityCheck(
    path: 'app/ios/Runner/Info.plist',
    expectedTokens: [
      '<key>CFBundleDisplayName</key>',
      '<string>Babel Fish</string>',
    ],
  ),
  _IdentityCheck(
    path: 'app/macos/Runner/Configs/AppInfo.xcconfig',
    expectedTokens: ['PRODUCT_NAME = Babel Fish'],
  ),
  _IdentityCheck(
    path: 'app/linux/runner/my_application.cc',
    expectedTokens: [
      'gtk_header_bar_set_title(header_bar, "Babel Fish");',
      'gtk_window_set_title(window, "Babel Fish");',
    ],
  ),
  _IdentityCheck(
    path: 'app/windows/runner/Runner.rc',
    expectedTokens: [
      'VALUE "FileDescription", "Babel Fish" "\\0"',
      'VALUE "ProductName", "Babel Fish" "\\0"',
    ],
  ),
  _IdentityCheck(
    path: 'app/web/manifest.json',
    expectedTokens: ['"name": "Babel Fish"', '"short_name": "Babel Fish"'],
  ),
];

final class _IdentityCheck {
  const _IdentityCheck({required this.path, required this.expectedTokens});

  final String path;
  final List<String> expectedTokens;
}
