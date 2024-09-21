import 'dart:io';

import 'package:mason/mason.dart';
import 'package:supagen/src/utils/extensions/extensions.dart';

class DartRepositoryGenerator {
  final Logger logger;

  DartRepositoryGenerator({
    required this.logger,
  });

  Future<void> generate({
    required String projectName,
    required Map<String, dynamic> tableDefinitions,
    String command = 'init',
  }) async {
    String path = './$projectName/lib/repositories';
    if (command == 'import') {
      path = './lib/repositories';

      if (!Directory(path).existsSync()) {
        throw '❌ Unable to find Dart repositories in: $path'; 
      }
    }
    logger.info('Generating Dart repositories in: $path...');


    final target = DirectoryGeneratorTarget(
      Directory.fromUri(Uri.parse(path)),
    );

    logger.info('Fetching Dart repository template...');
    final brick = Brick.git(
      const GitPath(
        'https://github.com/supagen/supagen_bricks.git',
        path: 'bricks/dart/repository',
      ),
    );
    final generator = await MasonGenerator.fromBrick(brick);
    logger.info('Dart repository template fetched successfully!');

    for (final table in tableDefinitions.keys) {
      logger.info('Generating Dart repository for table: $table...');
      await generator.generate(target, vars: <String, dynamic>{
        'model_name': table.singularize,
        'table_name': table,
      });
      logger.info('Dart repository generated successfully for table: $table');
    }

    logger.info('Dart repositories generated successfully in: $path');
  }
}
