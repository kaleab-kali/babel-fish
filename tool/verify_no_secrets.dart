import 'dart:convert';
import 'dart:io';

void main() {
  final violations = <String>[];

  for (final path in _trackedFiles()) {
    final lowerPath = path.toLowerCase();
    final extension = _extensionOf(lowerPath);

    if (_forbiddenArtifactExtensions.contains(extension)) {
      violations.add(
        '$path: tracked file uses a forbidden real recording or transcript '
        'artifact extension.',
      );
      continue;
    }

    if (!_shouldScanText(path, extension)) {
      continue;
    }

    final file = File(path);
    if (!file.existsSync()) {
      continue;
    }

    final bytes = file.readAsBytesSync();
    if (bytes.contains(0)) {
      continue;
    }

    final contents = utf8.decode(bytes, allowMalformed: true);
    for (final pattern in _secretPatterns) {
      if (pattern.expression.hasMatch(contents)) {
        violations.add('$path: possible ${pattern.name}.');
      }
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('Secret and real recording artifact check passed.');
    return;
  }

  stderr.writeln(
    'Do not commit provider keys, credentials, real recordings, or private '
    'transcripts. Found possible violations:',
  );
  for (final violation in violations) {
    stderr.writeln('- $violation');
  }

  exitCode = 1;
}

List<String> _trackedFiles() {
  final result = Process.runSync('git', ['ls-files']);
  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    exit(result.exitCode);
  }

  return LineSplitter.split(
    result.stdout as String,
  ).where((line) => line.trim().isNotEmpty).toList(growable: false);
}

bool _shouldScanText(String path, String extension) {
  final filename = path.split('/').last.toLowerCase();
  return _textExtensions.contains(extension) ||
      _textFilenames.contains(filename);
}

String _extensionOf(String path) {
  final filename = path.split('/').last;
  final index = filename.lastIndexOf('.');
  if (index == -1) {
    return '';
  }

  return filename.substring(index);
}

const _forbiddenArtifactExtensions = {
  '.aac',
  '.ass',
  '.flac',
  '.m4a',
  '.mkv',
  '.mov',
  '.mp3',
  '.mp4',
  '.ogg',
  '.opus',
  '.srt',
  '.transcript',
  '.vtt',
  '.wav',
  '.webm',
};

const _textExtensions = {
  '.cmake',
  '.cc',
  '.cpp',
  '.css',
  '.dart',
  '.entitlements',
  '.gradle',
  '.h',
  '.html',
  '.js',
  '.json',
  '.kt',
  '.kts',
  '.manifest',
  '.md',
  '.pbxproj',
  '.plist',
  '.properties',
  '.rc',
  '.storyboard',
  '.swift',
  '.ts',
  '.txt',
  '.xcconfig',
  '.xcscheme',
  '.xib',
  '.xml',
  '.yaml',
  '.yml',
};

const _textFilenames = {
  'agents.md',
  'code_of_conduct.md',
  'contributing.md',
  'license',
  'readme.md',
  'security.md',
};

final _secretPatterns = [
  _SecretPattern(
    name: 'OpenAI-style API key',
    expression: RegExp(r'\bsk-[A-Za-z0-9_-]{20,}\b'),
  ),
  _SecretPattern(
    name: 'GitHub token',
    expression: RegExp(r'\bgh[pousr]_[A-Za-z0-9_]{30,}\b'),
  ),
  _SecretPattern(
    name: 'Google API key',
    expression: RegExp(r'\bAIza[0-9A-Za-z_-]{35}\b'),
  ),
  _SecretPattern(
    name: 'AWS access key id',
    expression: RegExp(r'\bAKIA[0-9A-Z]{16}\b'),
  ),
  _SecretPattern(
    name: 'Slack token',
    expression: RegExp(r'\bxox[baprs]-[0-9A-Za-z-]{20,}\b'),
  ),
  _SecretPattern(
    name: 'private key block',
    expression: RegExp(
      r'-----BEGIN (?:RSA |DSA |EC |OPENSSH |PGP )?PRIVATE KEY-----',
    ),
  ),
];

final class _SecretPattern {
  const _SecretPattern({required this.name, required this.expression});

  final String name;
  final RegExp expression;
}
