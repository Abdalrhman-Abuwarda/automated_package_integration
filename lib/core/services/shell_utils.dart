import 'dart:io';

Future<void> runFlutterPubGet(String projectDir) async {
  final result = await Process.start(
    'flutter',
    ['pub', 'get'],
    workingDirectory: projectDir,
    runInShell: true,
  );
  stdout.addStream(result.stdout);
  stderr.addStream(result.stderr);

  final exitCode = await result.exitCode;
  if (exitCode != 0) {
    throw Exception('flutter pub get failed with exit code $exitCode');
  }
}
