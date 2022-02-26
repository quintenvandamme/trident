import 'package:Trident/globals/error.dart';
import 'package:Trident/install/wsl/x86_64.dart';
import 'package:Trident/install/wsl/arm64.dart';
import 'package:system_info2/system_info2.dart';

void install_wsl(kernel_version, kernel_type) {
  switch (SysInfo.kernelArchitecture) {
    case "x86_64":
      {
        switch (kernel_type) {
          case "RC":
            {
              install_wsl_rc_x86_64(kernel_version, kernel_type);
            }
            break;
          default:
            {
              install_wsl_mainline_x86_64(kernel_version, kernel_type);
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
              install_wsl_rc_arm64(kernel_version, kernel_type);
            }
            break;
          default:
            {
              install_wsl_mainline_arm64(kernel_version, kernel_type);
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
