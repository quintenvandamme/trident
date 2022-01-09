import 'package:Trident/version.dart';
import 'package:Trident/install.dart';
import 'package:Trident/catalog.dart';
import 'package:Trident/gpu_info.dart';
import 'package:Trident/globals/error.dart';
import "package:system_info/system_info.dart";

String trident_version = '0.0.3';
String trident_prerelease_version = '-rc3';

void main(arguments) async {
  var gpuinfo = await get_gpuinfo();
  if (gpuinfo == 1) {
    print(error_6);
  } else {
    await create_folder(path);
    await create_folder('$path/wsl2');
    try {
      if (arguments[0] == '--version') {
        version();
      } else if (arguments[0] == '--help') {
        help();
      } else if (arguments[0] == '--install') {
        if (arguments[1] == null) {
          print(error_1);
        } else if (arguments[1] == ' ') {
          print(error_1);
        } else {
          String? system_kernel = SysInfo.kernelVersion;
          if (system_kernel.contains('WSL2')) {
            print(
                'Trident detected you are using WSL2 switched to --wsl instead.');
            var kernel_version = arguments[1];
            var kernel_type = get_type(kernel_version);
            install_wsl(kernel_version, kernel_type);
          } else {
            var kernel_version = arguments[1];
            var kernel_type = get_type(kernel_version);
            var VER_STR = get_versionstring(kernel_version, kernel_type);
            var VER_STAND = get_versionstandalone(kernel_version, kernel_type);
            install_main(kernel_version, kernel_type, VER_STR, VER_STAND);
          }
        }
      } else if (arguments[0] == '--catalog') {
        if (arguments[1] == null) {
          print(error_1);
        } else if (arguments[1] == ' ') {
          print(error_1);
        } else {
          var kernel_version = arguments[1];
          var kernel_type = get_type(kernel_version);
          var VER_STR = get_versionstring(kernel_version, kernel_type);
          var VER_STAND = get_versionstandalone(kernel_version, kernel_type);
          catalog_main(kernel_version, kernel_type, VER_STR, VER_STAND);
        }
      } else if (arguments[0] == '--wsl') {
        if (arguments[1] == null) {
          print(error_1);
        } else if (arguments[1] == ' ') {
          print(error_1);
        } else {
          var kernel_version = arguments[1];
          var kernel_type = get_type(kernel_version);
          install_wsl(kernel_version, kernel_type);
        }
      }
    } catch (error) {
      print(error_2);
    }
  }
}

void version() {
  print('\x1B[94m' + '  _   _   _');
  print(
      ' / \\ / \\ / \\      Version:     $trident_version$trident_prerelease_version');
  print(
      ' | | | | | |      System:      ${SysInfo.kernelName} ${SysInfo.operatingSystemName} ${SysInfo.operatingSystemVersion}');
  print(' | | | | | |      Arch:        ${SysInfo.kernelArchitecture}');
  print(' \\ |_| |_| /      Kernel:      ${SysInfo.kernelVersion}');
  print('  \\__   __/');
  print('     | |');
  print('     | |');
  print('     | |');
  print('     \\_/' + '\x1B[0m');
}

void help() {
  print('--version               display version.');
  print('--help                  list all commands.');
  print('--install <kernel>      install specific kernel.');
  print('--catalog <kernel>      catalog specific kernel.');
  print('--wsl <kernel>          install specific kernel for wsl2.');
}
