import 'dart:convert';
import 'dart:io';

void main() {
  final violations = <String>[];

  for (final path in _trackedPubspecs()) {
    final contents = File(path).readAsStringSync();
    _expectLine(path, contents, 'repository: $_repositoryUrl', violations);
    _expectLine(path, contents, 'issue_tracker: $_issueTrackerUrl', violations);

    final requiredTopics = _requiredPackageTopics[path];
    if (requiredTopics != null) {
      for (final topic in requiredTopics) {
        _expectLine(path, contents, '  - $topic', violations);
      }
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('Pubspec metadata check passed.');
    return;
  }

  stderr.writeln('Pubspec files must keep open-source project metadata:');
  for (final violation in violations) {
    stderr.writeln('- $violation');
  }

  exitCode = 1;
}

List<String> _trackedPubspecs() {
  final result = Process.runSync('git', ['ls-files']);
  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    exit(result.exitCode);
  }

  return LineSplitter.split(result.stdout as String)
      .where((path) => path == 'pubspec.yaml' || path.endsWith('/pubspec.yaml'))
      .toList(growable: false);
}

void _expectLine(
  String path,
  String contents,
  String expected,
  List<String> violations,
) {
  final hasExpectedLine = LineSplitter.split(
    contents,
  ).any((line) => line.trimRight() == expected);
  if (!hasExpectedLine) {
    violations.add('$path: missing `$expected`.');
  }
}

const _repositoryUrl = 'https://github.com/kaleab-kali/babel-fish';
const _issueTrackerUrl = 'https://github.com/kaleab-kali/babel-fish/issues';

const _requiredPackageTopics = {
  'packages/babelfish_core/pubspec.yaml': [
    'speech',
    'translation',
    'captions',
    'dart',
  ],
  'packages/babelfish_fixtures/pubspec.yaml': [
    'speech',
    'translation',
    'fixtures',
    'dart',
  ],
  'packages/babelfish_providers/pubspec.yaml': [
    'speech',
    'translation',
    'providers',
    'dart',
  ],
};
