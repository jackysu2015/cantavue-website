import 'dart:io';

Future<void> main(List<String> args) async {
  Future<void> run(List<String> arguments) async {
    final process = await Process.start(
      Platform.resolvedExecutable,
      arguments,
      mode: ProcessStartMode.inheritStdio,
    );
    final code = await process.exitCode;
    if (code != 0) exit(code);
  }

  await run(['run', 'tool/build_document.dart', ...args]);
  await run([
    'run',
    'tool/flutter.dart',
    'build',
    'web',
    '--release',
    '--no-web-resources-cdn',
    '--pwa-strategy=none',
  ]);
  final destination = Directory('dist');
  if (destination.existsSync()) destination.deleteSync(recursive: true);
  destination.createSync();
  for (final entity in Directory('build/web').listSync(recursive: true)) {
    final relative = entity.path.substring('build/web/'.length);
    if (entity is Directory) {
      Directory('dist/$relative').createSync(recursive: true);
    }
    if (entity is File) {
      File('dist/$relative').parent.createSync(recursive: true);
      entity.copySync('dist/$relative');
    }
  }
  // A new release must not reuse a cached loader or application bundle.
  final revision = DateTime.now().toUtc().microsecondsSinceEpoch.toString();
  final bootstrap = File('dist/flutter_bootstrap.js');
  bootstrap.writeAsStringSync(
    bootstrap.readAsStringSync().replaceAll(
      'main.dart.js',
      'main.dart.js?v=$revision',
    ),
  );
  for (final file in destination.listSync().whereType<File>()) {
    if (file.path.endsWith('.html')) {
      file.writeAsStringSync(
        file.readAsStringSync().replaceAll(
          'src="flutter_bootstrap.js"',
          'src="flutter_bootstrap.js?v=$revision"',
        ),
      );
    }
  }
  stdout.writeln('Static website ready in dist/');
}
