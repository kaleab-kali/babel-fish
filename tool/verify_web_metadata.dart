import 'dart:convert';
import 'dart:io';

void main() {
  final violations = <String>[];
  _verifyIndexHtml(violations);
  _verifyManifest(violations);

  if (violations.isEmpty) {
    stdout.writeln('Flutter web metadata check passed.');
    return;
  }

  stderr.writeln('Flutter web metadata must stay complete and warning-free:');
  for (final violation in violations) {
    stderr.writeln('- $violation');
  }

  exitCode = 1;
}

void _verifyIndexHtml(List<String> violations) {
  final file = File(_indexPath);
  if (!file.existsSync()) {
    violations.add('$_indexPath is missing.');
    return;
  }

  final contents = file.readAsStringSync();
  _expectContains(
    violations,
    path: _indexPath,
    contents: contents,
    expected: '<html lang="en">',
  );
  _expectContains(
    violations,
    path: _indexPath,
    contents: contents,
    expected: '<title>Babel Fish</title>',
  );
  _expectContains(
    violations,
    path: _indexPath,
    contents: contents,
    expected:
        '<meta name="description" '
        'content="Fixture-backed speech translation captions.">',
  );
  _expectContains(
    violations,
    path: _indexPath,
    contents: contents,
    expected: '<meta name="theme-color" content="#0F766E">',
  );
  _expectContains(
    violations,
    path: _indexPath,
    contents: contents,
    expected: '<link rel="manifest" href="manifest.json">',
  );
  _expectContains(
    violations,
    path: _indexPath,
    contents: contents,
    expected: '<script src="flutter_bootstrap.js" async></script>',
  );

  if (contents.contains('<meta name="viewport"')) {
    violations.add(
      '$_indexPath must not define a viewport meta tag; Flutter web injects '
      'one at runtime and warns when a duplicate exists.',
    );
  }
}

void _verifyManifest(List<String> violations) {
  final file = File(_manifestPath);
  if (!file.existsSync()) {
    violations.add('$_manifestPath is missing.');
    return;
  }

  final manifest = Map<String, Object?>.from(
    jsonDecode(file.readAsStringSync()) as Map<dynamic, dynamic>,
  );

  _expectManifestValue(violations, manifest, 'name', 'Babel Fish');
  _expectManifestValue(violations, manifest, 'short_name', 'Babel Fish');
  _expectManifestValue(
    violations,
    manifest,
    'description',
    'Fixture-backed speech translation captions.',
  );
  _expectManifestValue(violations, manifest, 'theme_color', '#0F766E');
  _expectManifestValue(violations, manifest, 'background_color', '#F7FAF9');
  _expectManifestValue(violations, manifest, 'display', 'standalone');
  _expectManifestValue(violations, manifest, 'orientation', 'portrait-primary');

  final icons = manifest['icons'];
  if (icons is! List<Object?>) {
    violations.add('$_manifestPath: icons must be a list.');
    return;
  }

  final iconEntries = icons
      .whereType<Map<dynamic, dynamic>>()
      .map(Map<String, Object?>.from)
      .toList(growable: false);
  _expectIcon(violations, iconEntries, src: 'icons/Icon-192.png');
  _expectIcon(violations, iconEntries, src: 'icons/Icon-512.png');
  _expectIcon(
    violations,
    iconEntries,
    src: 'icons/Icon-maskable-192.png',
    purpose: 'maskable',
  );
  _expectIcon(
    violations,
    iconEntries,
    src: 'icons/Icon-maskable-512.png',
    purpose: 'maskable',
  );
}

void _expectContains(
  List<String> violations, {
  required String path,
  required String contents,
  required String expected,
}) {
  if (!contents.contains(expected)) {
    violations.add('$path: missing $expected');
  }
}

void _expectManifestValue(
  List<String> violations,
  Map<String, Object?> manifest,
  String key,
  String expected,
) {
  if (manifest[key] != expected) {
    violations.add('$_manifestPath: $key must be "$expected".');
  }
}

void _expectIcon(
  List<String> violations,
  List<Map<String, Object?>> icons, {
  required String src,
  String? purpose,
}) {
  final matchingIcons = icons.where((icon) {
    return icon['src'] == src &&
        (purpose == null || icon['purpose'] == purpose);
  });
  if (matchingIcons.isEmpty) {
    violations.add('$_manifestPath: missing icon $src.');
    return;
  }

  final iconFile = File('app/web/$src');
  if (!iconFile.existsSync()) {
    violations.add('$src is referenced by $_manifestPath but missing.');
  }
}

const _indexPath = 'app/web/index.html';
const _manifestPath = 'app/web/manifest.json';
