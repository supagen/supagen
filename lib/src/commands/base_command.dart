import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:supagen/src/utils/constants.dart';

abstract class BaseCommand extends Command<int> {
  final Logger logger;

  BaseCommand({required this.logger}) {
    logger.level = Level.info;

    argParser.addFlag(
      'verbose',
      abbr: 'v',
      help: 'Enable verbose logging',
      callback: (verbose) {
        if (verbose) {
          logger.level = Level.verbose;
        }
      },
    );
  }

  @override
  String get description => 'Command description';

  @override
  String get name => '$kPackageName command';

  @override
  String get invocation => '$kPackageName $name';

  bool get hasLifecycle => true;

  void beforeCommand() {
    logger.detail('Running $name command...');
  }

  void afterCommand() {
    logger.detail('Finished running $name command');
  }

  @override
  Future<int> run() async {
    if (!hasLifecycle) {
      final runCommandResult = await runCommand();
      return runCommandResult;
    }

    // Before running the command
    beforeCommand();

    final runCommandResult = await runCommand();

    // After running the command
    afterCommand();

    return runCommandResult;
  }

  Future<int> runCommand() {
    throw UnimplementedError('runCommand() not implemented');
  }
}
