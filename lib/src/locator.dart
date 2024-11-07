import 'package:get_it/get_it.dart';
import 'package:mason/mason.dart';
import 'package:supagen/supagen.dart';

final getIt = GetIt.instance;

void setup() {
  // Logger
  getIt.registerFactory<Logger>(() {
    return Logger();
  });

  // Runner
  getIt.registerFactory<SupagenCommandRunner>(() {
    return SupagenCommandRunner(
      logger: getIt.get<Logger>(),
    );
  });

  // Commands
  getIt.registerFactory<InitCommand>(() {
    return InitCommand();
  });
  getIt.registerFactory<VersionCommand>(() {
    return VersionCommand();
  });
  getIt.registerFactory<UpdateCommand>(() {
    return UpdateCommand();
  });
  getIt.registerFactory<GenerateCommand>(() {
    return GenerateCommand();
  });
}
