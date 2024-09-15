import 'dart:io';

import 'package:mason/mason.dart';

class FlutterProjectGenerator {
  final Logger logger;

  FlutterProjectGenerator({
    required this.logger,
  });

  Future<void> generate({
    required projectName,
    required supabaseUrl,
    required anonKey,
  }) async {
    final path = './$projectName';
    logger.info('Generating Flutter project in: $path...');

    final target = DirectoryGeneratorTarget(
      Directory.fromUri(Uri.parse(path)),
    );

    logger.info('Fetching Flutter project template...');
    final brick = Brick.git(
      const GitPath(
        'https://github.com/supagen/supagen_bricks.git',
        path: 'bricks/dart/flutter',
      ),
    );
    final generator = await MasonGenerator.fromBrick(brick);
    logger.info('Flutter project template fetched successfully!');

    await generator.generate(target, vars: <String, dynamic>{
      'project_name': projectName,
      'supabase_url': supabaseUrl,
      'anon_key': anonKey,
    });

    logger.info('Flutter project generated successfully!');
  }
}
