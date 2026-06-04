import 'dart:convert';
import 'dart:io';

void main() {
  final violations = <String>[];

  for (final path in _trackedMarkdownFiles()) {
    final file = File(path);
    if (!file.existsSync()) {
      continue;
    }

    final contents = file.readAsStringSync();
    final links = [
      ..._inlineLinks(path, contents),
      ..._referenceLinks(path, contents),
    ];

    for (final link in links) {
      final target = _cleanTarget(link.target);
      if (!_shouldVerify(target)) {
        continue;
      }

      final resolvedPath = _resolve(path, target);
      if (!File(resolvedPath).existsSync() &&
          !Directory(resolvedPath).existsSync()) {
        violations.add('${link.location}: missing $target');
      }
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('Markdown link check passed.');
    return;
  }

  stderr.writeln('Markdown links must point to existing local files:');
  for (final violation in violations) {
    stderr.writeln('- $violation');
  }

  exitCode = 1;
}

List<String> _trackedMarkdownFiles() {
  final result = Process.runSync('git', ['ls-files', '*.md']);
  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    exit(result.exitCode);
  }

  return LineSplitter.split(
    result.stdout as String,
  ).where((line) => line.trim().isNotEmpty).toList(growable: false);
}

Iterable<_MarkdownLink> _inlineLinks(String path, String contents) sync* {
  final lines = LineSplitter.split(contents).toList(growable: false);
  final expression = RegExp(r'!?\[[^\]]+\]\(([^)]+)\)');

  for (var index = 0; index < lines.length; index += 1) {
    for (final match in expression.allMatches(lines[index])) {
      yield _MarkdownLink(
        location: '$path:${index + 1}',
        target: match.group(1) ?? '',
      );
    }
  }
}

Iterable<_MarkdownLink> _referenceLinks(String path, String contents) sync* {
  final lines = LineSplitter.split(contents).toList(growable: false);
  final expression = RegExp(r'^\[[^\]]+\]:\s+(.+)$');

  for (var index = 0; index < lines.length; index += 1) {
    final match = expression.firstMatch(lines[index]);
    if (match == null) {
      continue;
    }

    yield _MarkdownLink(
      location: '$path:${index + 1}',
      target: match.group(1) ?? '',
    );
  }
}

String _cleanTarget(String target) {
  final trimmed = target.trim();
  final withoutTitle = trimmed.startsWith('<')
      ? trimmed
      : trimmed.split(RegExp(r'\s+')).first;
  return withoutTitle
      .replaceAll(RegExp(r'^<|>$'), '')
      .replaceFirst(RegExp(r'#.*$'), '');
}

bool _shouldVerify(String target) {
  if (target.isEmpty || target.startsWith('#')) {
    return false;
  }

  return !RegExp(r'^[a-zA-Z][a-zA-Z0-9+.-]*:').hasMatch(target);
}

String _resolve(String sourcePath, String target) {
  final sourceDirectory = File(sourcePath).parent.path;
  return File('$sourceDirectory/$target').absolute.normalizePath;
}

final class _MarkdownLink {
  const _MarkdownLink({required this.location, required this.target});

  final String location;
  final String target;
}

extension on FileSystemEntity {
  String get normalizePath => uri.toFilePath(windows: Platform.isWindows);
}
