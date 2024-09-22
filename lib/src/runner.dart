import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_completion/cli_completion.dart';
import 'package:mason/mason.dart';
import 'package:supagen/src/utils/constants.dart';
import 'package:supagen/supagen.dart';

class SupagenCommandRunner extends CompletionCommandRunner<int> {
  final Logger logger;

  SupagenCommandRunner({
    required this.logger,
  }) : super(kPackageName, kPackageDescription) {
    // List supagen commands
    addCommand(getIt.get<InitCommand>());
    addCommand(getIt.get<VersionCommand>());
    addCommand(getIt.get<UpdateCommand>());
  }

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      return await runCommand(parse(args)) ?? ExitCode.success.code;
    } on UsageException catch (e) {
      logger
        ..err(e.message)
        ..info('')
        ..info(e.usage);

      return ExitCode.usage.code;
    } on MasonException catch (e) {
      logger.err(e.message);

      return ExitCode.usage.code;
    } on ProcessException catch (error) {
      logger.err(error.message);

      return ExitCode.unavailable.code;
    } catch (error) {
      logger.err('$error');

      return ExitCode.software.code;
    }
  }

  @override
  Future<int?> runCommand(ArgResults topLevelResults) async {
    int? exitCode = ExitCode.unavailable.code;
    exitCode = await super.runCommand(topLevelResults);

    return exitCode;
  }
}
