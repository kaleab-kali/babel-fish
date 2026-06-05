import 'dart:convert';
import 'dart:io';

void main() {
  final violations = <String>[];

  for (final path in _trackedFixtureFiles()) {
    final file = File(path);
    if (!file.existsSync()) {
      continue;
    }

    final contents = file.readAsStringSync();
    for (final pattern in _forbiddenPatternsFor(path)) {
      if (pattern.expression.hasMatch(contents)) {
        violations.add('$path: ${pattern.description}');
      }
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('Fixture offline-mode check passed.');
    return;
  }

  stderr.writeln(
    'Fixture mode must stay offline and deterministic. Found forbidden '
    'network or capture API usage:',
  );
  for (final violation in violations) {
    stderr.writeln('- $violation');
  }

  exitCode = 1;
}

List<String> _trackedFixtureFiles() {
  final result = Process.runSync('git', [
    'ls-files',
    'app/lib',
    'app/pubspec.yaml',
    'packages/babelfish_fixtures/lib',
    'packages/babelfish_fixtures/pubspec.yaml',
  ]);
  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    exit(result.exitCode);
  }

  return LineSplitter.split(
    result.stdout as String,
  ).where((line) => line.trim().isNotEmpty).toList(growable: false);
}

List<_ForbiddenPattern> _forbiddenPatternsFor(String path) {
  if (path.endsWith('pubspec.yaml')) {
    return _forbiddenDependencyPatterns;
  }

  return _forbiddenSourcePatterns;
}

final _forbiddenDependencyPatterns = [
  _ForbiddenPattern(
    description: 'fixture mode must not depend on package:http.',
    expression: RegExp(r'^\s*http\s*:', multiLine: true),
  ),
  _ForbiddenPattern(
    description: 'fixture mode must not depend on dio.',
    expression: RegExp(r'^\s*dio\s*:', multiLine: true),
  ),
  _ForbiddenPattern(
    description: 'fixture mode must not depend on web_socket_channel.',
    expression: RegExp(r'^\s*web_socket_channel\s*:', multiLine: true),
  ),
  _ForbiddenPattern(
    description: 'fixture mode must not depend on grpc.',
    expression: RegExp(r'^\s*grpc\s*:', multiLine: true),
  ),
];

final _forbiddenSourcePatterns = [
  _ForbiddenPattern(
    description: 'fixture mode source must not import dart:io.',
    expression: RegExp(r'''import\s+['"]dart:io['"]'''),
  ),
  _ForbiddenPattern(
    description: 'fixture mode source must not import dart:html.',
    expression: RegExp(r'''import\s+['"]dart:html['"]'''),
  ),
  _ForbiddenPattern(
    description: 'fixture mode source must not import package:http.',
    expression: RegExp(r'''import\s+['"]package:http/'''),
  ),
  _ForbiddenPattern(
    description: 'fixture mode source must not import dio.',
    expression: RegExp(r'''import\s+['"]package:dio/'''),
  ),
  _ForbiddenPattern(
    description: 'fixture mode source must not use HttpClient.',
    expression: RegExp(r'\bHttpClient\b'),
  ),
  _ForbiddenPattern(
    description: 'fixture mode source must not use WebSocket.',
    expression: RegExp(r'\bWebSocket\b'),
  ),
  _ForbiddenPattern(
    description: 'fixture mode source must not call fetch.',
    expression: RegExp(r'\bfetch\s*\('),
  ),
  _ForbiddenPattern(
    description: 'fixture mode source must not use XMLHttpRequest.',
    expression: RegExp(r'\bXMLHttpRequest\b'),
  ),
  _ForbiddenPattern(
    description: 'fixture mode source must not request media devices.',
    expression: RegExp(r'\bgetUserMedia\b'),
  ),
];

final class _ForbiddenPattern {
  const _ForbiddenPattern({
    required this.description,
    required this.expression,
  });

  final String description;
  final RegExp expression;
}
