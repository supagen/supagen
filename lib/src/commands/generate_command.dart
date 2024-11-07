import 'package:mason/mason.dart';
import 'package:supagen/src/commands/base_command.dart';
import 'package:supagen/src/generators/docs/c4_generator.dart';
import 'package:supagen/src/utils/constants.dart';
import 'package:supagen/src/utils/extensions/string_extensions.dart';
import 'package:supagen/supagen.dart';

class GenerateCommand extends BaseCommand {
  @override
  final name = 'generate';

  @override
  String get description => 'Generate code for your project';

  GenerateCommand() : super(logger: getIt.get()) {
    argParser.addOption(
      'type',
      abbr: 't',
      help: 'The type of code to generate',
      valueHelp: 'type',
    );
  }

  @override
  Future<int> runCommand() async {
    String type = argResults?['type'] ?? '';

    final supportedTypes = [
      kC4,
    ];

    if (type.isNullOrEmpty) {
      type = logger.chooseOne(
        '❓ Select type of code to generate',
        choices: supportedTypes,
        defaultValue: kC4,
      );
    }

    switch (type) {
      case kC4:
        final generator = C4Generator(logger: logger);

        final projectName = logger.prompt('❓ Enter your project name:');
        if (projectName.isNullOrEmpty) {
          logger.err('❌ Please provide a $type project name');
          return ExitCode.usage.code;
        }
        final projectDescription = logger.prompt('❓ Enter your project name:');
        if (projectDescription.isNullOrEmpty) {
          logger.err('❌ Please provide a $type project description');
          return ExitCode.usage.code;
        }

        await generator.generate(
          projectName: projectName,
          projectDescription: projectDescription,
        );
        break;
      default:
    }

    return ExitCode.success.code;
  }
}
