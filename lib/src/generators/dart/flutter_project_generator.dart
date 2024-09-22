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
    logger.detail('Generating Flutter project in: $path...');

    final target = DirectoryGeneratorTarget(
      Directory.fromUri(Uri.parse(path)),
    );

    logger.detail('Fetching Flutter project template...');
    final brick = Brick.git(
      const GitPath(
        'https://github.com/supagen/supagen_bricks.git',
        path: 'bricks/dart/flutter',
      ),
    );
    final generator = await MasonGenerator.fromBrick(brick);
    logger.detail('Flutter project template fetched successfully!');

    await generator.generate(target, vars: <String, dynamic>{
      'project_name': projectName,
      'supabase_url': supabaseUrl,
      'anon_key': anonKey,
    });

    logger.detail('Flutter project generated successfully!');
  }
}
