// import 'dart:io';
// import '../core/utils/logger.dart';
//
// class Shell {
//   final _logger = Logger.stdout();
//
//   Future<void> run(String exe, List<String> args, {required String wd}) async {
//     _logger.info('▶️  \$ $exe ${args.join(' ')}');
//     final proc = await Process.start(exe, args, workingDirectory: wd, runInShell: true);
//     await stdout.addStream(proc.stdout);
//     await stderr.addStream(proc.stderr);
//     final code = await proc.exitCode;
//     if (code != 0) {
//       _logger.warn('Process exited with code \$code');
//       throw ProcessException(exe, args, 'Exit $code', code);
//     }
//   }
// }