import 'dart:io';
import 'package:Trident/web.dart';
import 'package:Trident/globals/error.dart';
import 'package:Trident/globals/path.dart';
import 'package:process_run/shell.dart';

var shell = Shell();

installrc_arm64(
    kernel_version, kernel_type, VER_STR, VER_STAND, secretstr) async {
  var status = await get_status(kernel_version);
  var status_arm64 = status[1];
  switch (status_arm64) {
    case "success":
      {
        await download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-headers-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
                '_arm64.deb',
            '1arm.deb');
        await download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-image-unsigned-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
                '_arm64.deb',
            '2arm.deb');
        await download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-modules-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
                '_arm64.deb',
            '3arm.deb');
        Directory.current = '$path_download';
        await shell.run('''sudo dpkg -i *arm.deb''');
      }
      break;

    default:
      {
        print(error_11);
      }
      break;
  }
}

installmainline_arm64(
    kernel_version, kernel_type, VER_STR, VER_STAND, secretstr) async {
  var status = await get_status(kernel_version);
  var status_arm64 = status[1];
  switch (status_arm64) {
    case "success":
      {
        await download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-headers-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_arm64.deb',
            '1arm.deb');
        await download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-image-unsigned-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_arm64.deb',
            '2arm.deb');
        await download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-modules-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_arm64.deb',
            '3arm.deb');
        Directory.current = '$path_download';
        await shell.run('''sudo dpkg -i *arm.deb''');
      }
      break;

    default:
      {
        print(error_11);
      }
      break;
  }
}
