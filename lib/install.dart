import 'dart:io';
import 'package:Trident/web.dart';
import "package:system_info/system_info.dart";
import 'package:process_run/shell.dart';

final path = '/tmp/tridentdownloadcache';

install_main(kernel_version, kernel_type, VER_STR, VER_STAND) {
  if (kernel_type == 'RC') {
    get_file(kernel_version).whenComplete(() {
      installrc(kernel_version, kernel_type, VER_STR, VER_STAND);
    });
  } else {
    get_file(kernel_version).whenComplete(() {
      installmainline(kernel_version, kernel_type, VER_STR, VER_STAND);
    });
  }
}

Future<void> create_folder() async {
  final pathexists = await Directory(path).exists();
  if (pathexists == true) {
    await Directory(path).delete(recursive: true);
    await Directory(path).create(recursive: true);
  } else {
    await Directory(path).create(recursive: true);
  }
}

installrc(kernel_version, kernel_type, VER_STR, VER_STAND) async {
  var status = await get_status(kernel_version);
  var status_amd64 = status[0];
  var status_arm64 = status[1];

  var status_amd64_bit = 1;
  var status_arm64_bit = 1;
  if (status_amd64 == 'failed') {
    status_amd64_bit = 0;
  }
  if (status_arm64 == 'failed') {
    status_arm64_bit = 0;
  }

  install_1(secretstr) async {
    await create_folder();
    if (status_amd64 == 'failed') {
      if (status_arm64 == 'failed') {
      } else if (status_amd64 == 'failed') {
        await download_deb(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-headers-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
                '_arm64.deb',
            '5arm.deb');
        await download_deb(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-image-unsigned-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
                '_arm64.deb',
            '6arm.deb');
        await download_deb(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-modules-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
                '_arm64.deb',
            '7arm.deb');
      }
    } else if (status_arm64 == 'failed') {
      if (status_amd64 == 'failed') {
      } else if (status_arm64 == 'failed') {
        await download_deb(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
                '_amd64.deb',
            '1amd.deb');
        await download_deb(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$VER_STAND-' +
                '$VER_STR' +
                '_$VER_STAND-$VER_STR.$secretstr' +
                '_all.deb',
            '2amd.deb');
        await download_deb(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-image-unsigned-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
                '_amd64.deb',
            '3amd.deb');
        await download_deb(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-modules-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
                '_amd64.deb',
            '4amd.deb');
      }
    } else {
      await download_deb(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
              '_amd64.deb',
          '1amd.deb');
      await download_deb(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$VER_STAND-' +
              '$VER_STR' +
              '_$VER_STAND-$VER_STR.$secretstr' +
              '_all.deb',
          '2amd.deb');
      await download_deb(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-image-unsigned-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
              '_amd64.deb',
          '3amd.deb');
      await download_deb(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-modules-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
              '_amd64.deb',
          '4amd.deb');
      await download_deb(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-headers-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
              '_arm64.deb',
          '5arm.deb');
      await download_deb(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-image-unsigned-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
              '_arm64.deb',
          '6arm.deb');
      await download_deb(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-modules-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
              '_arm64.deb',
          '7arm.deb');
    }
  }

  install_2() async {
    var shell = Shell();
    if (SysInfo.kernelArchitecture == 'x86_64') {
      await shell.run('''sudo dpkg -i *amd.deb''');
    } else {
      await shell.run('''sudo dpkg -i *arm.deb''');
    }
  }

  if (status_amd64 == 'failed') {
    if (status_arm64 == 'failed') {
    } else if (status_amd64 == 'failed') {
      String? secretstr = get_secretstr(
          'arm64/linux-headers-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR',
          kernel_version);
      await install_1(secretstr);
      install_2();
    }
  } else if (status_arm64 == 'failed') {
    if (status_amd64 == 'failed') {
    } else if (status_arm64 == 'failed') {
      String? secretstr = get_secretstr(
          'amd64/linux-headers-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR',
          kernel_version);
      await install_1(secretstr);
      install_2();
    }
  } else {
    String? secretstr = get_secretstr(
        'amd64/linux-headers-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR',
        kernel_version);
    await install_1(secretstr);
    install_2();
  }
}

installmainline(kernel_version, kernel_type, VER_STR, VER_STAND) async {
  var status = await get_status(kernel_version);
  var status_amd64 = status[0];
  var status_arm64 = status[1];

  var status_amd64_bit = 1;
  var status_arm64_bit = 1;
  if (status_amd64 == 'failed') {
    status_amd64_bit = 0;
  }
  if (status_arm64 == 'failed') {
    status_arm64_bit = 0;
  }

  install_1(secretstr) async {
    await create_folder();
    if (status_amd64 == 'failed') {
      if (status_arm64 == 'failed') {
      } else if (status_amd64 == 'failed') {
        download_deb(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-headers-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_arm64.deb',
            '5arm.deb');
        download_deb(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-image-unsigned-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_arm64.deb',
            '6arm.deb');
        download_deb(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-modules-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_arm64.deb',
            '7arm.deb');
      }
    } else if (status_arm64 == 'failed') {
      if (status_amd64 == 'failed') {
      } else if (status_arm64 == 'failed') {
        download_deb(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_amd64.deb',
            '1amd.deb');
        download_deb(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$kernel_version-' +
                '$VER_STR' +
                '_$kernel_version-$VER_STR.$secretstr' +
                '_all.deb',
            '2amd.deb');
        download_deb(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-image-unsigned-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_amd64.deb',
            '3amd.deb');
        download_deb(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-modules-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_amd64.deb',
            '4amd.deb');
      }
    } else {
      download_deb(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
              '_amd64.deb',
          '1amd.deb');
      download_deb(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$kernel_version-' +
              '$VER_STR' +
              '_$kernel_version-$VER_STR.$secretstr' +
              '_all.deb',
          '2amd.deb');
      download_deb(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-image-unsigned-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
              '_amd64.deb',
          '3amd.deb');
      download_deb(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-modules-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
              '_amd64.deb',
          '4amd.deb');
      download_deb(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-headers-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
              '_arm64.deb',
          '5arm.deb');
      download_deb(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-image-unsigned-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
              '_arm64.deb',
          '6arm.deb');
      download_deb(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-modules-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
              '_arm64.deb',
          '7arm.deb');
    }
  }

  install_2() async {
    var shell = Shell();
    if (SysInfo.kernelArchitecture == 'x86_64') {
      //await shell.run('''sudo dpkg -i *amd.deb''');
      print('sudo dpkg -i *amd.deb');
    } else {
      //await shell.run('''sudo dpkg -i *arm.deb''');
      print('sudo dpkg -i *arm.deb');
    }
  }

  if (status_amd64 == 'failed') {
    if (status_arm64 == 'failed') {
    } else if (status_amd64 == 'failed') {
      String? secretstr = get_secretstr(
          'arm64/linux-headers-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR',
          kernel_version);
      await install_1(secretstr);
      install_2();
    }
  } else if (status_arm64 == 'failed') {
    if (status_amd64 == 'failed') {
    } else if (status_arm64 == 'failed') {
      String? secretstr = get_secretstr(
          'amd64/linux-headers-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR',
          kernel_version);
      await install_1(secretstr);
      install_2();
    }
  } else {
    String? secretstr = get_secretstr(
        'amd64/linux-headers-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR',
        kernel_version);
    await install_1(secretstr);
    install_2();
  }
}
