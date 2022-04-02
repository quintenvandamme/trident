import 'dart:io';
import 'package:system_info2/system_info2.dart';
import 'package:Trident/globals/error.dart';
import 'package:Trident/sys/device.dart';
import 'package:Trident/kernel/main.dart';

// check if the kernel you want to install is lower than what you currently have.
kernel_version_is_lower(kernel_version) async {
  if (is_wsl() == true) {
    var system_kernel =
        SysInfo.kernelVersion.replaceAll('-microsoft-standard-WSL2', '');
    system_kernel = SysInfo.kernelVersion.replaceAll('-trident-WSL2', '');
    var system_kernel_int = convert_kernel_toint(system_kernel);
    var wslgithub_kernel_int =
        convert_kernel_toint(await get_wsl_kernel_config_info());
    var kernel_version_int = convert_kernel_toint(kernel_version);
    if (system_kernel == kernel_version) {
      return false;
    } else if (system_kernel_int > kernel_version_int) {
      return true;
    } else if (wslgithub_kernel_int > kernel_version_int) {
      print(error_14);
      exit(0);
    }
  } else {
    var system_kernel_int = convert_kernel_toint(SysInfo.kernelVersion);
    var kernel_version_int = convert_kernel_toint(kernel_version);
    if (system_kernel_int > kernel_version_int) {
      return true;
    }
  }
}

// check if the kernel you want to install is the same as you currently have.
kernel_version_is_same(kernel_version) {
  if (is_wsl() == true) {
    var system_kernel =
        SysInfo.kernelVersion.replaceAll('-microsoft-standard-WSL2', '');
    system_kernel = SysInfo.kernelVersion.replaceAll('-trident-WSL2', '');
    if (system_kernel == kernel_version) {
      return true;
    } else {
      return false;
    }
  } else {
    if (SysInfo.kernelVersion == kernel_version) {
      return true;
    }
  }
}
