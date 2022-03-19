import 'package:Trident/web.dart';
import 'package:Trident/globals/error.dart';
import 'package:Trident/install/generic/x86_64.dart';
import 'package:Trident/install/generic/arm64.dart';
import 'package:system_info2/system_info2.dart';

void install_main(kernel_version, kernel_type, VER_STR, VER_STAND) async {
  String? secretstr = get_secretstr(
      'arm64/linux-headers-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR',
      kernel_version);
  switch (SysInfo.kernelArchitecture) {
    case "x86_64":
      {
        switch (kernel_type) {
          case "RC":
            {
              await installrc_x86_64(
                  kernel_version, kernel_type, VER_STR, VER_STAND, secretstr);
            }
            break;
          default:
            {
              await installmainline_x86_64(
                  kernel_version, kernel_type, VER_STR, VER_STAND, secretstr);
            }
            break;
        }
      }
      break;

    case "ARM":
      {
        switch (kernel_type) {
          case "RC":
            {
              await installrc_arm64(
                  kernel_version, kernel_type, VER_STR, VER_STAND, secretstr);
            }
            break;
          default:
            {
              await installmainline_arm64(
                  kernel_version, kernel_type, VER_STR, VER_STAND, secretstr);
            }
            break;
        }
      }
      break;

    default:
      {
        print(error_10);
      }
      break;
  }
}

void compile_main(kernel_version, kernel_type) {
  compile_main_x86_64(kernel_version, kernel_type);
}
