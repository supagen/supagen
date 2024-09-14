import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:supagen/src/utils/constants.dart';

abstract class BaseCommand extends Command<int> {
  final Logger logger;

  BaseCommand({
    required this.logger,
  });

  @override
  String get description => 'Command description';

  @override
  String get name => '$kPackageName command';

  @override
  String get invocation => '$kPackageName $name';

  void beforeCommand() {
    logger.info('Running $name command...');
  }

  void afterCommand() {
    logger.info('Finished running $name command');
  }

  @override
  Future<int> run() async {
    // Before running the command
    beforeCommand();

    final runCommandResult = runCommand();

    // After running the command
    afterCommand();

    return runCommandResult;
  }

  Future<int> runCommand() {
    throw UnimplementedError('runCommand() not implemented');
  }
}
