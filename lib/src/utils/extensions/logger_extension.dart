import 'package:mason/mason.dart';
import 'package:supagen/src/utils/constants.dart';
import 'package:supagen/src/version.dart' as version;

extension LoggerExtensions on Logger {
  void supagenVersion() {
    // https://patorjk.com/software/taag/#p=display&f=RubiFont&t=supagen
    info("""
 ▗▄▄▖▗▖ ▗▖▗▄▄▖  ▗▄▖  ▗▄▄▖▗▄▄▄▖▗▖  ▗▖
▐▌   ▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▐▌   ▐▌   ▐▛▚▖▐▌
 ▝▀▚▖▐▌ ▐▌▐▛▀▘ ▐▛▀▜▌▐▌▝▜▌▐▛▀▀▘▐▌ ▝▜▌
▗▄▄▞▘▝▚▄▞▘▐▌   ▐▌ ▐▌▝▚▄▞▘▐▙▄▄▖▐▌  ▐▌                                                                                 
    """);
    info(kPackageDescription);
    info('Version: ${version.packageVersion}');
    info(
        '---------------------------------------------------------------------------');
  }
}
