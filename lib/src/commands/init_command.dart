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
    String template = argResults?['template'] ?? '';
    String project = argResults?['project'] ?? '';
    String supabaseUrl = argResults?['supabase_url'] ?? '';
    String anonKey = argResults?['anon_key'] ?? '';

    final supportedTemplates = [
      kFlutter,
    ];
    if (!template.isNullOrEmpty && !supportedTemplates.contains(template)) {
      logger.err('❌ Unsupported template: $template');
      return ExitCode.usage.code;
    }

    if (template.isNullOrEmpty) {
      template = logger.chooseOne(
        '❓ Select your project template :',
        choices: supportedTemplates,
        defaultValue: kFlutter,
      );
    }
    if (project.isNullOrEmpty) {
      project = logger.prompt('❓ Enter your $template project name :');
      if (project.isNullOrEmpty) {
        logger.err('❌ Please provide a $template project name');
        return ExitCode.usage.code;
      }
    }
    if (supabaseUrl.isNullOrEmpty) {
      supabaseUrl = logger.prompt('❓ Enter your Supabase project url :');
      if (supabaseUrl.isNullOrEmpty) {
        logger.err('❌ Please provide a Supabase project url');
        return ExitCode.usage.code;
      }
    }
    if (anonKey.isNullOrEmpty) {
      anonKey = logger.prompt('❓ Enter your Supabase anon key :', hidden: true);
      if (anonKey.isNullOrEmpty) {
        logger.err('❌ Please provide a Supabase anon key');
        return ExitCode.usage.code;
      }
    }

    Progress progress = logger.progress('Generating $template project...');

    logger.detail('Fetching table definitions from Supabase project...');
    final supabaseService = SupabaseService(
      supabaseUrl: supabaseUrl,
      anonKey: anonKey,
    );
    final tableDefinitions = await supabaseService.getTableDefinitions();
    logger.detail('Table definitions fetched successfully!');

    if (template == kFlutter) {
      await _initFlutterProject(
        project,
        supabaseUrl,
        anonKey,
        tableDefinitions,
      );
    }

    progress.complete('Project generated successfully! 🚀');

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

    final repositoryGenerator = DartRepositoryGenerator(logger: logger);
    await repositoryGenerator.generate(
      projectName: projectName,
      tableDefinitions: tableDefinitions,
    );
  }
}
