import 'dart:io';

import 'package:mason/mason.dart';

class C4Generator {
  final Logger logger;

  C4Generator({
    required this.logger,
  });

  Future<void> generate({
    required String projectName,
    required String projectDescription,
  }) async {
    final path = './';
    logger.detail('Generating C4 in: $path...');

    final target = DirectoryGeneratorTarget(
      Directory.fromUri(Uri.parse(path)),
    );

    logger.detail('Fetching C4 template...');
    final brick = Brick.git(
      const GitPath(
        'https://github.com/supagen/supagen_bricks.git',
        path: 'bricks/docs/c4',
      ),
    );
    final generator = await MasonGenerator.fromBrick(brick);
    logger.detail('C4 template fetched successfully');

    await generator.generate(target, vars: <String, dynamic>{
      'project_name': projectName,
      'project_description': projectDescription,
    });

    logger.detail('Dart repositories generated successfully in: $path');
  }
}
