import 'dart:io';
import 'package:Trident/kernel/version.dart';
import 'package:Trident/kernel/latest.dart';
import 'package:Trident/sys/file_handler.dart';
import 'package:Trident/sys/system.dart';
import 'package:Trident/sys/checks.dart';
import 'package:Trident/sys/config.dart';
import 'package:Trident/web/update.dart';
import 'package:Trident/globals/error.dart';
import 'package:Trident/globals/path.dart';
import 'package:Trident/globals/package_info.dart';
import 'package:Trident/install/generic/main.dart';
import 'package:Trident/install/wsl/main.dart';
import 'package:system_info2/system_info2.dart';

void main(arguments) async {
  // configs
  var get_config = new config();

  var checkforupdates = get_config.checkforupdates();

  void check_if_kernel_is_lower(kernel_version) async {
    if (await kernel_version_is_lower(kernel_version) == true) {
      print(error_12);
      exit(0);
    }
  }

  void wsl() async {
    var kernel = arguments[1];
    switch (kernel) {
      case "latest_mainline":
        {
          var kernel_version = await latest_mainline_kernel();
          var kernel_type = get_type(kernel_version);
          check_if_kernel_is_lower(kernel_version);
          install_wsl(kernel_version, kernel_type);
        }
        break;

      case "latest_rc":
        {
          var kernel_version = await latest_rc_kernel();
          var kernel_type = get_type(kernel_version);
          check_if_kernel_is_lower(kernel_version);
          install_wsl(kernel_version, kernel_type);
        }
        break;

      case "latest_lts":
        {
          var kernel_version = await latest_lts_kernel();
          var kernel_type = get_type(kernel_version);
          check_if_kernel_is_lower(kernel_version);
          install_wsl(kernel_version, kernel_type);
        }
        break;

      default:
        {
          var kernel_version = arguments[1];
          var kernel_type = get_type(kernel_version);
          check_if_kernel_is_lower(kernel_version);
          install_wsl(kernel_version, kernel_type);
        }
        break;
    }
  }

  void commands() async {
    await create_folder(path, 'false');
    await create_folder(path_download, 'true');
    await create_folder('$path_download/wsl2', 'true');
    await create_folder('$path_download/linux', 'true');
    try {
      var command = arguments[0];
      switch (command) {
        case "--version":
          {
            version();
          }
          break;

        case "-version":
          {
            version();
          }
          break;

        case "-help":
          {
            print('''
--version              display version.
-help                  list all commands.
-update                check for and install updates.
-install <kernel>      install specific kernel from binary.
-compile <kernel>      build and install specific kernel.
-wsl <kernel>          build and install specific kernel for wsl2.''');
          }
          break;

        case "-compile":
          {
            var kernel = arguments[1];
            String system_kernel = SysInfo.kernelVersion;
            if (system_kernel.contains('WSL2')) {
              print(
                  'Trident detected you are using WSL2 switched to -wsl instead.');
              wsl();
            } else {
              switch (kernel) {
                case "latest_mainline":
                  {
                    var kernel_version = await latest_mainline_kernel();
                    var kernel_type = get_type(kernel_version);
                    check_if_kernel_is_lower(kernel_version);
                    compile_main(kernel_version, kernel_type);
                  }
                  break;

                case "latest_rc":
                  {
                    var kernel_version = await latest_rc_kernel();
                    var kernel_type = get_type(kernel_version);
                    check_if_kernel_is_lower(kernel_version);
                    compile_main(kernel_version, kernel_type);
                  }
                  break;

                case "latest_lts":
                  {
                    var kernel_version = await latest_lts_kernel();
                    var kernel_type = get_type(kernel_version);
                    check_if_kernel_is_lower(kernel_version);
                    compile_main(kernel_version, kernel_type);
                  }
                  break;

                default:
                  {
                    var kernel_version = arguments[1];
                    var kernel_type = get_type(kernel_version);
                    check_if_kernel_is_lower(kernel_version);
                    compile_main(kernel_version, kernel_type);
                  }
                  break;
              }
            }
          }
          break;

        case "-install":
          {
            var kernel = arguments[1];
            String system_kernel = SysInfo.kernelVersion;
            if (system_kernel.contains('WSL2')) {
              print(
                  'Trident detected you are using WSL2 switched to -wsl instead.');
              wsl();
            } else {
              switch (kernel) {
                case "latest_mainline":
                  {
                    var kernel_version =
                        await latest_mainline_kernel_kernelubuntucom();
                    var kernel_type = get_type(kernel_version);
                    var VER_STR =
                        get_versionstring(kernel_version, kernel_type);
                    var VER_STAND =
                        get_versionstandalone(kernel_version, kernel_type);
                    check_if_kernel_is_lower(kernel_version);
                    install_main(
                        kernel_version, kernel_type, VER_STR, VER_STAND);
                  }
                  break;

                case "latest_rc":
                  {
                    var kernel_version =
                        await latest_rc_kernel_kernelubuntucom();
                    var kernel_type = get_type(kernel_version);
                    var VER_STR =
                        get_versionstring(kernel_version, kernel_type);
                    var VER_STAND =
                        get_versionstandalone(kernel_version, kernel_type);
                    check_if_kernel_is_lower(kernel_version);
                    install_main(
                        kernel_version, kernel_type, VER_STR, VER_STAND);
                  }
                  break;

                case "latest_lts":
                  {
                    var kernel_version =
                        await latest_lts_kernel_kernelubuntucom();
                    var kernel_type = get_type(kernel_version);
                    var VER_STR =
                        get_versionstring(kernel_version, kernel_type);
                    var VER_STAND =
                        get_versionstandalone(kernel_version, kernel_type);
                    check_if_kernel_is_lower(kernel_version);
                    install_main(
                        kernel_version, kernel_type, VER_STR, VER_STAND);
                  }
                  break;

                default:
                  {
                    var kernel_version = arguments[1];
                    var kernel_type = get_type(kernel_version);
                    var VER_STR =
                        get_versionstring(kernel_version, kernel_type);
                    var VER_STAND =
                        get_versionstandalone(kernel_version, kernel_type);
                    check_if_kernel_is_lower(kernel_version);
                    install_main(
                        kernel_version, kernel_type, VER_STR, VER_STAND);
                  }
                  break;
              }
            }
          }
          break;

        case "-update":
          {
            try {
              var update_status = await checkforupdate();
              switch (update_status) {
                case true:
                  {
                    await update();
                  }
                  break;
                default:
                  {
                    print('No updates found.');
                  }
                  break;
              }
            } catch (error) {
              print(error_9);
            }
          }
          break;

        case "-wsl":
          {
            wsl();
          }
          break;
      }
    } catch (error) {
      print(error_2);
    }
  }

  system_uses_apt();
  var gpuinfo = await get_gpuinfo();
  switch (gpuinfo) {
    case true:
      {
        print(error_6);
      }
      break;
    case false:
      {
        try {
          var update_status = await checkforupdate();
          if (checkforupdates == true) {
            switch (update_status) {
              case true:
                {
                  var update_status = prompt_update();
                  if (update_status == true) {
                    await update();
                    commands();
                  }
                }
                break;
              default:
                {
                  commands();
                }
                break;
            }
          } else {
            commands();
          }
        } catch (error) {
          print(error_9);
          commands();
        }
      }
  }
}

void version() {
  print('\x1B[94m' + '  _   _   _');
  print(' / \\ / \\ / \\      ' +
      '\x1B[0m' +
      '\x1b[37m' +
      '${SysInfo.userName}@${Platform.localHostname}' +
      '\x1B[0m' +
      '\x1B[94m');
  print(' | | | | | |');
  print(
      ' | | | | | |      Version:     $trident_version$trident_prerelease_version');
  print(
      ' \\ |_| |_| /      System:      ${SysInfo.kernelName} ${SysInfo.operatingSystemName} ${SysInfo.operatingSystemVersion}');
  print('  \\__   __/       Arch:        ${SysInfo.kernelArchitecture}');
  print('     | |          Kernel:      ${SysInfo.kernelVersion}');
  print('     | |');
  print('     | |');
  print('     \\_/' + '\x1B[0m');
}
