import 'dart:io';
import 'package:system_info2/system_info2.dart';
import 'package:Trident/globals/error.dart';
import 'package:Trident/sys/device.dart';
import 'package:Trident/sys/file_handler.dart';
import 'package:Trident/kernel/main.dart';

// check if the kernel you want to install is lower than what you currently have.
kernel_version_is_lower(kernel_version) async {
  if (is_wsl() == true) {
    var system_kernel = null;
    if (SysInfo.kernelVersion.contains('-microsoft-standard-WSL2')) {
      // remove third . in system_kernel eg ( 5.10.102.1 becomes 5.10.102 )
      system_kernel = SysInfo.kernelVersion
          .replaceAll('-microsoft-standard-WSL2', '')
          .split('.')
          .take(3)
          .join('.');
    } else if (SysInfo.kernelVersion.contains('-trident-WSL2')) {
      system_kernel = SysInfo.kernelVersion.replaceAll('-trident-WSL2', '');
    }
    if (convert_kernel_toint(system_kernel) ==
        convert_kernel_toint(kernel_version)) {
      return false;
    } else if (convert_kernel_toint(system_kernel) >
        convert_kernel_toint(kernel_version)) {
      return true;
    } else if (convert_kernel_toint(await get_wsl_kernel_config_info()) >
        convert_kernel_toint(kernel_version)) {
      print(error_14);
      exit(0);
    }
  } else {
    // fix where generic ubuntu kernels (eg 5.13.0-39-generic) fails the checks.
    var system_kernel_int = null;
    if (SysInfo.kernelVersion.contains('-rc')) {
      var system_kernel_part = SysInfo.kernelVersion.split('-rc');
      var system_kernel_part2 = system_kernel_part[0];
      var system_kernel_length = system_kernel_part2.length + 4;
      var system_kernel =
          SysInfo.kernelVersion.substring(0, system_kernel_length);
      system_kernel_int = convert_kernel_toint(system_kernel);
    } else if (SysInfo.kernelVersion.contains('generic')) {
      var system_kernel_part = SysInfo.kernelVersion.split('-');
      system_kernel_int = convert_kernel_toint(system_kernel_part[0]);
    } else {
      system_kernel_int = convert_kernel_toint(SysInfo.kernelVersion);
    }
    var kernel_version_int = convert_kernel_toint(kernel_version);
    if (system_kernel_int > kernel_version_int) {
      return true;
    } else {
      return false;
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

system_uses_apt() {
  if (file_exists('/var/cache/apt/pkgcache.bin') == false) {
    print(error_15);
    exit(0);
  }
}
