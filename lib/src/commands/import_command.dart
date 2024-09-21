import 'dart:io';

import 'package:mason/mason.dart';
import 'package:supagen/src/commands/base_command.dart';
import 'package:supagen/src/generators/dart/dart_generator.dart';
import 'package:supagen/src/services/supabase_service.dart';
import 'package:supagen/src/utils/extensions/extensions.dart';
import 'package:supagen/supagen.dart';

class ImportCommand extends BaseCommand {
  @override
  final name = 'import';

  @override
  String get description => 'Import Supabase table definitions';

  ImportCommand() : super(logger: getIt.get());

  @override
  Future<int> runCommand() async {
    final envFile = File('.env');

    if (!envFile.existsSync()) {
      logger.err('❌ Unable to find .env file in the project directory');
      return ExitCode.usage.code;
    }

    final envFileContent = envFile.readAsStringSync();
    final envFileLines = envFileContent.split('\n');

    String supabaseUrl =
        envFileLines.firstWhere((line) => line.startsWith('SUPABASE_URL='));
    String anonKey = envFileLines
        .firstWhere((line) => line.startsWith('SUPABASE_ANON_KEY='));

    if (supabaseUrl.isNullOrEmpty) {
      logger.err('❌ Please provide a Supabase project URL');
      return ExitCode.usage.code;
    }

    supabaseUrl = supabaseUrl.replaceAll('SUPABASE_URL=', '');

    if (anonKey.isNullOrEmpty) {
      logger.err('❌ Please provide a Supabase anon key');
      return ExitCode.usage.code;
    }

    anonKey = anonKey.replaceAll('SUPABASE_ANON_KEY=', '');

    logger.info('Fetching table definitions from Supabase project...');
    final supabaseService = SupabaseService(
      supabaseUrl: supabaseUrl,
      anonKey: anonKey,
    );
    final tableDefinitions = await supabaseService.getTableDefinitions();
    logger.info('Table definitions fetched successfully!');

    await _importFlutterProject(
      supabaseUrl,
      anonKey,
      tableDefinitions,
    );

    return ExitCode.success.code;
  }

  Future<void> _importFlutterProject(
    String supabaseUrl,
    String anonKey,
    Map<String, dynamic> tableDefinitions,
  ) async {
    final modelGenerator = DartModelGenerator(logger: logger);
    await modelGenerator.generate(
      projectName: 'supagen',
      tableDefinitions: tableDefinitions,
      command: 'import',
    );

    final repositoryGenerator = DartRepositoryGenerator(logger: logger);
    await repositoryGenerator.generate(
      projectName: 'supagen',
      tableDefinitions: tableDefinitions,
      command: 'import',
    );
  }
}
