import 'dart:async';

import 'package:mason/mason.dart';
import 'package:supagen/src/commands/base_command.dart';
import 'package:supagen/src/generators/dart/dart_generator.dart';
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
      'project',
      abbr: 'n',
      help: 'The name of the project',
      valueHelp: 'project',
    );
    argParser.addOption(
      'supabase_url',
      abbr: 'p',
      help: 'The Supabase project URL',
      valueHelp: 'supabase_url',
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
    final project = argResults!['project'] as String?;
    final supabaseUrl = argResults!['supabase_url'] as String?;
    final anonKey = argResults!['anon_key'] as String?;

    if (template.isNullOrEmpty) {
      logger.err('Please provide a template');
      return ExitCode.usage.code;
    }
    if (project.isNullOrEmpty) {
      logger.err('Please provide a project name');
      return ExitCode.usage.code;
    }
    if (supabaseUrl.isNullOrEmpty) {
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
      supabaseUrl: supabaseUrl!,
      anonKey: anonKey!,
    );
    final tableDefinitions = await supabaseService.getTableDefinitions();
    logger.info('Table definitions fetched successfully!');

    if (template == kFlutter) {
      await _initFlutterProject(
        project!,
        supabaseUrl,
        anonKey,
        tableDefinitions,
      );
    }

    logger.info('Project generated successfully!');

    return ExitCode.success.code;
  }

  Future<void> _initFlutterProject(
    String projectName,
    String supabaseUrl,
    String anonKey,
    Map<String, dynamic> tableDefinitions,
  ) async {
    final flutterProjectGenerator = FlutterProjectGenerator(logger: logger);
    await flutterProjectGenerator.generate(
      projectName: projectName,
      supabaseUrl: supabaseUrl,
      anonKey: anonKey,
    );

    final modelGenerator = DartModelGenerator(logger: logger);
    await modelGenerator.generate(
      projectName: projectName,
      tableDefinitions: tableDefinitions,
    );
  }
}
