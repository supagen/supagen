import 'dart:async';
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:supagen/src/commands/base_command.dart';
import 'package:supagen/src/utils/constants.dart';
import 'package:supagen/src/utils/extensions/extensions.dart';
import 'package:supagen/supagen.dart';

class InitCommand extends BaseCommand {
  @override
  final name = 'init';

  @override
  String get description => 'Initialize a new Supabase project';

  InitCommand() : super(logger: getIt.get()) {
    argParser.addOption(
      'template',
      abbr: 't',
      help: 'The template to use for generating the project',
      valueHelp: 'template',
    );
  }

  @override
  Future<int> runCommand() async {
    final template = argResults!['template'] as String?;

    if (template.isNullOrEmpty) {
      logger.err('Please provide a template');
      return ExitCode.usage.code;
    }

    logger.info('Initializing Supabase project using template: $template');

    if (template == kFlutter) {
      await _initFlutterProject();
    }

    logger.info('Project generated successfully!');

    return ExitCode.success.code;
  }

  // Just an example, it will be replaced with the actual implementation
  Future<void> _initFlutterProject() async {
    final brick = Brick.git(
      const GitPath(
        'https://github.com/felangel/mason.git',
        path: 'bricks/greeting',
      ),
    );
    final generator = await MasonGenerator.fromBrick(brick);
    final target = DirectoryGeneratorTarget(Directory.current);
    await generator.generate(target, vars: <String, dynamic>{'name': 'Dash'});
  }
}
