import 'package:Trident/version.dart';
import 'package:Trident/install.dart';
import 'package:Trident/catalog.dart';
import 'package:Trident/gpu_info.dart';
import 'package:Trident/update.dart';
import 'package:Trident/globals/error.dart';
import 'package:Trident/globals/path.dart';
import 'package:Trident/globals/package_info.dart';
import 'package:system_info2/system_info2.dart';

void main(arguments) async {
  var gpuinfo = await get_gpuinfo();
  if (gpuinfo == 1) {
    print(error_6);
  } else {
    try {
      var update_status = await checkforupdate();
      if (update_status == 1) {
        var update_status = prompt_update();
        if (update_status == true) {
          await update();
        }
      }
    } catch (error) {
      print(error_9);
    }
    await create_folder(path, 'false');
    await create_folder(path_download, 'true');
    await create_folder('$path_download/wsl2', 'true');
    await create_folder('$path_download/linux', 'true');
    try {
      if (arguments[0] == '--version') {
        version();
      } else if (arguments[0] == '-version') {
        version();
      } else if (arguments[0] == '-help') {
        help();
      } else if (arguments[0] == '-install') {
        if (arguments[1] == null) {
          print(error_1);
        } else if (arguments[1] == ' ') {
          print(error_1);
        } else {
          String system_kernel = SysInfo.kernelVersion;
          if (system_kernel.contains('WSL2')) {
            print(
                'Trident detected you are using WSL2 switched to -wsl instead.');
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
      } else if (arguments[0] == '-catalog') {
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
      } else if (arguments[0] == '-update') {
        try {
          var update_status = await checkforupdate();
          if (update_status == 1) {
            await update();
          } else {
            print('No updates found.');
          }
        } catch (error) {
          print(error_9);
        }
      } else if (arguments[0] == '-wsl') {
        if (arguments[1] == null) {
          print(error_1);
        } else if (arguments[1] == ' ') {
          print(error_1);
        } else {
          var kernel_version = arguments[1];
          var kernel_type = get_type(kernel_version);
          install_wsl(kernel_version, kernel_type);
        }
      } else if (arguments[0] == '-compile') {
        if (arguments[1] == null) {
          print(error_1);
        } else if (arguments[1] == ' ') {
          print(error_1);
        } else {
          String system_kernel = SysInfo.kernelVersion;
          if (system_kernel.contains('WSL2')) {
            print(
                'Trident detected you are using WSL2 switched to -wsl instead.');
            var kernel_version = arguments[1];
            var kernel_type = get_type(kernel_version);
            install_wsl(kernel_version, kernel_type);
          } else {
            var kernel_version = arguments[1];
            var kernel_type = get_type(kernel_version);
            compile_main(kernel_version, kernel_type);
          }
        }
      } else if (arguments[0].startsWith('--')) {
        print(error_8);
      }
    } catch (error) {
      print(error_2);
    }
  }
}

void version() {
  print('\x1B[94m' + '  _   _   _');
  print(' / \\ / \\ / \\      Version:     $trident_version');
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
  print('--version              display version.');
  print('-help                  list all commands.');
  print('-update                check and install updates.');
  print('-install <kernel>      install specific kernel from binary.');
  print('-compile <kernel>      build and install specific kernel.');
  print('-wsl <kernel>          build and install specific kernel for wsl2.');
  print('-catalog <kernel>      catalog specific kernel.');
}
