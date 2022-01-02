import 'dart:io' show Platform;
import 'package:Trident/version.dart';
import 'package:Trident/install.dart';
import 'package:Trident/catalog.dart';
import "package:system_info/system_info.dart";

String VER = '0.0.2';

void main(arguments) {
  try {
    if (arguments[0] == '--version') {
      version();
    } else if (arguments[0] == '--help') {
      help();
    } else if (arguments[0] == '--install') {
      if (arguments[1] == '') {
        print('No kernel provided.');
      } else if (arguments[1] == ' ') {
        print('No kernel provided.');
      } else {
        var kernel_version = arguments[1];
        var kernel_type = get_type(kernel_version);
        var VER_STR = get_versionstring(kernel_version, kernel_type);
        var VER_STAND = get_versionstandalone(kernel_version, kernel_type);
        install_main(kernel_version, kernel_type, VER_STR, VER_STAND);
      }
    } else if (arguments[0] == '--catalog') {
      if (arguments[1] == '') {
        print('No kernel provided.');
      } else if (arguments[1] == ' ') {
        print('No kernel provided.');
      } else {
        var kernel_version = arguments[1];
        var kernel_type = get_type(kernel_version);
        var VER_STR = get_versionstring(kernel_version, kernel_type);
        var VER_STAND = get_versionstandalone(kernel_version, kernel_type);
        catalog_main(kernel_version, kernel_type, VER_STR, VER_STAND);
      }
    }
  } catch (error) {
    print('Please type a valid command.');
  }
}

void version() async {
  print('\x1B[94m' + '  _   _   _');
  print(' / \\ / \\ / \\      Version:     $VER');
  print(
      ' | | | | | |      System:      ${SysInfo.kernelName} ${SysInfo.operatingSystemName} ${SysInfo.operatingSystemVersion}');
  print(' | | | | | |      Arch:        ${SysInfo.kernelArchitecture}');
  print(' \\ |_| |_| /      Kernel Ver:  ${SysInfo.kernelVersion}');
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
}

void install(kernel) {}
