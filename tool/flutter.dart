import 'dart:convert';
import 'dart:io';

// Keeps this project's build output separate from any global Flutter override.
// Does not edit the SDK, HOME, global settings, signing accounts, or other apps.
Future<void> main(List<String> args) async {
  final environment = Map<String, String>.of(Platform.environment);
  final flutter = Platform.isWindows ? 'flutter.bat' : 'flutter';
  if (Platform.isMacOS || Platform.isLinux) {
    final userHome = environment['HOME'];
    if (userHome == null) {
      stderr.writeln('Cannot resolve Flutter configuration without HOME.');
      exitCode = 1;
      return;
    }
    final legacy = File('$userHome/.flutter_settings');
    if (legacy.existsSync()) {
      stderr.writeln(
        'Legacy global Flutter settings take precedence over '
        'project isolation. Review them before using this wrapper.',
      );
      exitCode = 1;
      return;
    }
    final originalDirectory =
        environment['XDG_CONFIG_HOME'] ?? '$userHome/.config/flutter';
    final original = File('$originalDirectory/settings');
    final config = original.existsSync()
        ? jsonDecode(original.readAsStringSync()) as Map<String, dynamic>
        : <String, dynamic>{};
    config['build-dir'] = 'build';
    final local = Directory('work/flutter_config')..createSync(recursive: true);
    File('${local.path}/settings').writeAsStringSync(jsonEncode(config));
    environment['XDG_CONFIG_HOME'] = local.absolute.path;
  } else if (Platform.isWindows) {
    final result = await Process.run(flutter, [
      'config',
      '--list',
    ], runInShell: true);
    final output = result.stdout as String;
    if (result.exitCode != 0 ||
        RegExp(
          r'build-dir: (?!\(Not set\)|build\s*$).+',
          multiLine: true,
        ).hasMatch(output)) {
      stderr.writeln(
        'Check the global Flutter build-dir before continuing. '
        'This wrapper will not change global settings.',
      );
      exitCode = 1;
      return;
    }
  }
  final process = await Process.start(
    flutter,
    ['--suppress-analytics', ...args],
    environment: environment,
    runInShell: Platform.isWindows,
    mode: ProcessStartMode.inheritStdio,
  );
  exitCode = await process.exitCode;
}
