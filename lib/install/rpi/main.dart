import 'dart:io';
import 'package:process_run/shell.dart';
import 'package:Trident/globals/path.dart';
import 'package:Trident/sys/file_handeler.dart';
import 'package:Trident/web.dart';

// source https://www.raspberrypi-spy.co.uk/2012/09/checking-your-raspberry-pi-board-version/ and https://elinux.org/RPi_HardwareHistory

final List bcmrpi = [
  // 32bit
  // Raspberry Pi 1, Zero and Zero W, and Raspberry Pi Compute Module 1 default
  'Beta', //Model B Beta
  '0002', //Model B Rev 1
  '0003', //Model B Rev 1 ECN0001 (no fuses, D14 removed)
  '0004', //Model B Rev 2
  '0005', //Model B Rev 2
  '0006', //Model B Rev 2
  '0007', //Model A
  '0008', //Model A
  '0009', //Model A
  '000d', //Model B Rev 2
  '000e', //Model B Rev 2
  '000f', //Model B Rev 2
  '0010', //Model B+
  '0013', //Model B+
  '900021', //Model A+
  '900032', //Model B+
  '0011', //Compute Module 1
  '0014', //Compute Module 1
  '0012', //Model A+
  '0013', //Model B+
  '0015', //Model A+
  '900092', //Pi Zero v1.2
  '900093', //Pi Zero v1.3
  '920093', //Pi Zero v1.3
  '9000C1' //Pi Zero W
];

final List bcm2709 = [
  // 32bit
  // Raspberry Pi 2, 3, 3+ and Zero 2 W, and Raspberry Pi Compute Modules 3 and 3+ default
  'a01040', //Pi 2 Model B v1.0
  'a01041', //Pi 2 Model B v1.1
  'a21041', //Pi 2 Model B v1.1
  'a22042', //Pi 2 Model B (with BCM2837) v1.2
  'a02082', //Pi 3 Model B
  'a22082', //Pi 3 Model B
  'a32082', //Pi 3 Model B
  'a020d3', //Pi 3 Model B+
  '9020e0', //Pi 3 Model A+
  'a020a0', //Compute Module 3 (and CM3 Lite)
  'a02100', //Compute Module 3+
  '902120' //Pi Zero 2 W
];

final List bcm271132 = [
  // 32bit
  // Raspberry Pi 4 and 400, and Raspberry Pi Compute Module 4 default
  'a03111', //Pi 4 1.1
  'b03111', //Pi 4 1.1
  'b03112', //Pi 4 1.2
  'b03114', //Pi 4 1.4
  'c03111', //Pi 4 1.1
  'c03112', //Pi 4 1.2
  'c03114', //Pi 4 1.4
  'd03114', //Pi 4 1.4
  'c03130' //Pi 400
];

final List bcm271164 = [
  // 64bit
  // Raspberry Pi 3, 3+, 4, 400 and Zero 2 W, and Raspberry Pi Compute Modules 3, 3+ and 4 default
  'a02082', //Pi 3 Model B
  'a22082', //Pi 3 Model B
  'a32082', //Pi 3 Model B
  'a020d3', //Pi 3 Model B+
  '9020e0', //Pi 3 Model A+
  'a020a0', //Compute Module 3 (and CM3 Lite)
  'a02100', //Compute Module 3+
  'a03111', //Pi 4 1.1
  'b03111', //Pi 4 1.1
  'b03112', //Pi 4 1.2
  'b03114', //Pi 4 1.4
  'c03111', //Pi 4 1.1
  'c03112', //Pi 4 1.2
  'c03114', //Pi 4 1.4
  'd03114', //Pi 4 1.4
  'c03130', //Pi 400
  '902120' //Pi Zero 2 W
];

get_branch(kernel_version) {
  var kernel_branch = kernel_version.substring(0, 4);
  if (kernel_branch.endsWith('.')) {
    kernel_branch = kernel_version.substring(0, 3);
  }
  return kernel_branch;
}

void compile_rpi(kernel_version, {arch = 32}) async {
  var branch = await get_branch(kernel_version);
  var kernel_config = await get_kernel_config(arch);
  var KERNEL = kernel_config[0];
  var defconfig = kernel_config[1];
  var shell = Shell();
  final path_exists = await File('$path_download/rpi/linux').exists();
  if (path_exists == true) {
    Directory.current = '$path_download/rpi/linux';
    await shell.run('''git pull''');
  } else {
    await create_folder('$path_download/rpi', false);
    Directory.current = '$path_download/rpi';
    await shell
        .run('''sudo apt install unzip git bc bison flex libssl-dev make -y''');
    await shell.run('''git clone https://github.com/raspberrypi/linux.git''');
    Directory.current = '$path_download/rpi/linux';
  }
  await shell.run('''git checkout rpi-$branch.y''');
  var commit = await Process.run(
    'git',
    ["log", "-1", "--grep='$kernel_version'"],
  );
  var kernelvercommit_part0 = commit.stdout;
  if (kernelvercommit_part0.contains('commit')) {
    var kernelvercommit_part1 = kernelvercommit_part0.split('commit');
    var kernelvercommit_part2 = kernelvercommit_part1[1].trim();
    var kernelvercommit_part3 = kernelvercommit_part2.replaceAll("\n", " ");
    var kernelvercommit_part4 = kernelvercommit_part3.split('Author');
    var kernelvercommit_part5 = kernelvercommit_part4[0].trim();
    var kernelvercommit = kernelvercommit_part5.replaceAll(" ", "");
    await create_folder('$path_download/rpi/build', true);
    Directory.current = '$path_download/rpi/build';
    await download_file(
        'https://github.com/raspberrypi/linux/archive/$kernelvercommit.zip',
        '/rpi/build/kernel.zip');
    await shell.run('''unzip $kernelvercommit.zip''');
    Directory.current = '$path_download/rpi/build/linux-$kernelvercommit';
    if (KERNEL == 'kernel8' && defconfig == 'bcm2711_defconfig') {
      // compile 64
      await shell.run(
          '''make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- $defconfig''');
    } else {
      //compile 32
      await shell.run(
          '''make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- $defconfig''');
    }
  } else {
    print('error version not found');
  }
}

get_board_revision() async {
  var cpuinfo = await Process.run(
    'cat',
    ['/proc/cpuinfo'],
  );
  var cpuinfo_part0 = cpuinfo.stdout;
  var cpuinfo_part1 = cpuinfo_part0.split('Revision');
  var cpuinfo_part2 = cpuinfo_part1[1].trim();
  var cpuinfo_part3 = cpuinfo_part2.replaceAll("\n", " ");
  var cpuinfo_part4 = cpuinfo_part3.replaceAll(": ", "");
  return cpuinfo_part4.replaceAll(" ", "");
}

get_kernel_config(arch) async {
  final String? board_revision = await get_board_revision();
  if (arch == 64) {
    if (bcm271164.contains(board_revision)) {
      return ['kernel8', 'bcm2711_defconfig'];
    } else if (bcmrpi.contains(board_revision)) {
      return ['kernel', 'bcmrpi_defconfig'];
    } else if (bcm2709.contains(board_revision)) {
      return ['kernel7', 'bcm2709_defconfig'];
    } else if (bcm271132.contains(board_revision)) {
      return ['kernel7l', 'bcm2711_defconfig'];
    }
  } else {
    if (bcmrpi.contains(board_revision)) {
      return ['kernel', 'bcmrpi_defconfig'];
    } else if (bcm2709.contains(board_revision)) {
      return ['kernel7', 'bcm2709_defconfig'];
    } else if (bcm271132.contains(board_revision)) {
      return ['kernel7l', 'bcm2711_defconfig'];
    }
  }
}
