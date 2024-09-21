import 'dart:io';

import 'package:cli_pkg/cli_pkg.dart' as pkg;
import 'package:grinder/grinder.dart';
import 'package:supagen/src/utils/constants.dart';

const _packageName = kPackageName;
const owner = kPackageName;
const repo = kPackageName;

void main(List<String> args) {
  pkg.name.value = _packageName;
  pkg.humanName.value = _packageName;
  pkg.githubUser.value = owner;
  pkg.githubRepo.value = '$owner/$repo';
  pkg.githubBearerToken.value = Platform.environment['GITHUB_TOKEN'];

  pkg.addAllTasks();

  grind(args);
}

@Task('Compile')
void compile() {
  run(
    'dart',
    arguments: ['compile', 'exe', 'bin/main.dart', '-o', _packageName],
  );
}
