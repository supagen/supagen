import 'dart:io';

import 'package:supagen/supagen.dart';
import 'package:supagen/src/locator.dart' as locator;

Future<void> main(List<String> args) async {
  locator.setup();

  final runner = getIt.get<SupagenCommandRunner>();

  await flushThenExit(await runner.run(args));
}

/// Flushes the stdout and stderr streams, then exits the program with the given
/// status code.
///
/// This returns a Future that will never complete, since the program will have
/// exited already. This is useful to prevent Future chains from proceeding
/// after you've decided to exit.
Future<dynamic> flushThenExit(int status) {
  return Future.wait<void>([stdout.close(), stderr.close()])
      .then<void>((_) => exit(status));
}
