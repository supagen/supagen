import 'dart:async';

import 'package:mason/mason.dart';
import 'package:supagen/src/commands/base_command.dart';
import 'package:supagen/src/generators/dart/dart_model_generator.dart';
import 'package:supagen/src/services/supabase_service.dart';
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
    argParser.addOption(
      'project_url',
      abbr: 'p',
      help: 'The Supabase project URL',
      valueHelp: 'project_url',
    );
    argParser.addOption(
      'anon_key',
      abbr: 'a',
      help: 'The Supabase anon key',
      valueHelp: 'anon_key',
    );
  }

  @override
  Future<int> runCommand() async {
    final template = argResults!['template'] as String?;
    final projectUrl = argResults!['project_url'] as String?;
    final anonKey = argResults!['anon_key'] as String?;

    if (template.isNullOrEmpty) {
      logger.err('Please provide a template');
      return ExitCode.usage.code;
    }
    if (projectUrl.isNullOrEmpty) {
      logger.err('Please provide a Supabase project URL');
      return ExitCode.usage.code;
    }
    if (anonKey.isNullOrEmpty) {
      logger.err('Please provide a Supabase anon key');
      return ExitCode.usage.code;
    }

    logger.info('Initializing Supabase project using template: $template');

    logger.info('Fetching table definitions from Supabase project...');
    final supabaseService = SupabaseService(
      projectUrl: projectUrl!,
      anonKey: anonKey!,
    );
    final tableDefinitions = await supabaseService.getTableDefinitions();
    logger.info('Table definitions fetched successfully!');

    if (template == kFlutter) {
      await _initFlutterProject(tableDefinitions);
    }

    logger.info('Project generated successfully!');

    return ExitCode.success.code;
  }

  Future<void> _initFlutterProject(
    Map<String, dynamic> tableDefinitions,
  ) async {
    final modelGenerator = DartModelGenerator(logger: logger);
    await modelGenerator.generate(tableDefinitions);
  }
}
