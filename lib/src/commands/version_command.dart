import 'dart:async';

import 'package:mason/mason.dart';
import 'package:supagen/src/commands/base_command.dart';
import 'package:supagen/src/utils/constants.dart';
import 'package:supagen/supagen.dart';

class VersionCommand extends BaseCommand {
  @override
  final name = 'version';

  @override
  String get description => 'Print the current version of $kPackageName';

  VersionCommand() : super(logger: getIt.get());

  @override
  Future<int> runCommand() async {
    return ExitCode.success.code;
  }
}
