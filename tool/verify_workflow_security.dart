import 'dart:convert';
import 'dart:io';

void main() {
  final violations = <String>[];

  for (final path in _trackedWorkflowFiles()) {
    final contents = File(path).readAsStringSync();
    _verifyWorkflow(path, contents, violations);
  }

  if (violations.isEmpty) {
    stdout.writeln('Workflow security check passed.');
    return;
  }

  stderr.writeln('GitHub Actions workflows must keep least-privilege guards:');
  for (final violation in violations) {
    stderr.writeln('- $violation');
  }

  exitCode = 1;
}

List<String> _trackedWorkflowFiles() {
  final result = Process.runSync('git', [
    'ls-files',
    '.github/workflows/*.yml',
    '.github/workflows/*.yaml',
  ]);
  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    exit(result.exitCode);
  }

  return LineSplitter.split(
    result.stdout as String,
  ).where((line) => line.trim().isNotEmpty).toList(growable: false);
}

void _verifyWorkflow(String path, String contents, List<String> violations) {
  if (contents.contains('pull_request_target:')) {
    violations.add('$path: pull_request_target is not allowed.');
  }

  if (RegExp(
    r'^\s*permissions:\s*write-all\s*$',
    multiLine: true,
  ).hasMatch(contents)) {
    violations.add('$path: permissions: write-all is not allowed.');
  }

  if (RegExp(
    r'^\s*contents:\s*write\s*$',
    multiLine: true,
  ).hasMatch(contents)) {
    violations.add('$path: contents: write is not allowed.');
  }

  if (!RegExp(r'^permissions:\s*$', multiLine: true).hasMatch(contents)) {
    violations.add('$path: missing explicit top-level permissions block.');
  }

  final runsOnCount = RegExp(
    r'^\s*runs-on:\s+',
    multiLine: true,
  ).allMatches(contents).length;
  final timeoutCount = RegExp(
    r'^\s*timeout-minutes:\s+\d+',
    multiLine: true,
  ).allMatches(contents).length;
  if (runsOnCount != timeoutCount) {
    violations.add('$path: each job with runs-on must define timeout-minutes.');
  }

  if (path != _deployWorkflowPath) {
    _expectNoPagesPermissions(path, contents, violations);
    return;
  }

  _verifyDeployWorkflow(contents, violations);
}

void _expectNoPagesPermissions(
  String path,
  String contents,
  List<String> violations,
) {
  if (RegExp(r'^\s*pages:\s*write\s*$', multiLine: true).hasMatch(contents)) {
    violations.add('$path: pages: write is only allowed in deploy-web.yml.');
  }

  if (RegExp(
    r'^\s*id-token:\s*write\s*$',
    multiLine: true,
  ).hasMatch(contents)) {
    violations.add('$path: id-token: write is only allowed in deploy-web.yml.');
  }
}

void _verifyDeployWorkflow(String contents, List<String> violations) {
  for (final expected in [
    'github.event_name != \'pull_request\'',
    'github.ref == \'refs/heads/main\'',
    'vars.BABEL_FISH_PAGES_DEPLOY == \'true\'',
    'uses: actions/configure-pages@v6',
    'uses: actions/upload-pages-artifact@v5',
    'uses: actions/deploy-pages@v5',
  ]) {
    if (!contents.contains(expected)) {
      violations.add('$_deployWorkflowPath: missing deploy guard $expected.');
    }
  }
}

const _deployWorkflowPath = '.github/workflows/deploy-web.yml';
