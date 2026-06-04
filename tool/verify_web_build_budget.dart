import 'dart:io';

const _buildDirectoryPath = 'app/build/web';
const _mainScriptPath = 'app/build/web/main.dart.js';
const _bytesPerMebibyte = 1024 * 1024;

const _mainScriptBudgetBytes = 3 * _bytesPerMebibyte;
const _totalBuildBudgetBytes = 45 * _bytesPerMebibyte;

void main() {
  final violations = <String>[];
  final buildDirectory = Directory(_buildDirectoryPath);
  final mainScript = File(_mainScriptPath);

  if (!buildDirectory.existsSync() || !mainScript.existsSync()) {
    stderr.writeln(
      'Web build artifact not found. Run `flutter build web` from app/ before '
      'running this verifier.',
    );
    exitCode = 1;
    return;
  }

  final mainScriptSize = mainScript.lengthSync();
  final totalBuildSize = _directorySize(buildDirectory);

  if (mainScriptSize > _mainScriptBudgetBytes) {
    violations.add(
      'main.dart.js is ${_formatBytes(mainScriptSize)}, above the '
      '${_formatBytes(_mainScriptBudgetBytes)} budget.',
    );
  }

  if (totalBuildSize > _totalBuildBudgetBytes) {
    violations.add(
      'app/build/web is ${_formatBytes(totalBuildSize)}, above the '
      '${_formatBytes(_totalBuildBudgetBytes)} budget.',
    );
  }

  if (violations.isEmpty) {
    stdout.writeln('Web build size budget check passed.');
    stdout.writeln(
      '- main.dart.js: ${_formatBytes(mainScriptSize)} / '
      '${_formatBytes(_mainScriptBudgetBytes)}',
    );
    stdout.writeln(
      '- app/build/web: ${_formatBytes(totalBuildSize)} / '
      '${_formatBytes(_totalBuildBudgetBytes)}',
    );
    return;
  }

  stderr.writeln('Web build size budget check failed:');
  for (final violation in violations) {
    stderr.writeln('- $violation');
  }
  exitCode = 1;
}

int _directorySize(Directory directory) {
  var total = 0;
  for (final entity in directory.listSync(recursive: true)) {
    if (entity is File) {
      total += entity.lengthSync();
    }
  }
  return total;
}

String _formatBytes(int bytes) {
  final mebibytes = bytes / _bytesPerMebibyte;
  return '${mebibytes.toStringAsFixed(1)} MiB';
}
