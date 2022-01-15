import 'dart:io';
import 'package:Trident/web.dart';
import 'package:Trident/globals/error.dart';
import "package:system_info/system_info.dart";
import 'package:process_run/shell.dart';

var path = '/tmp/tridentdownloadcache';
var shell = Shell();
var status_amd64_bit = 1;
var status_arm64_bit = 1;

void install_main(kernel_version, kernel_type, VER_STR, VER_STAND) {
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

void install_wsl(kernel_version, kernel_type) async {
  String? system_kernel = SysInfo.kernelVersion;
  if (system_kernel.contains('-WSL2')) {
    system_kernel = system_kernel.replaceAll('-microsoft-standard-WSL2', '');
    void wrtite_catalog(str, file) {
      new File(file).writeAsStringSync(str, mode: FileMode.append);
    }

    get_username() async {
      var runpwd = await Process.run(
        'pwd',
        [''],
      );
      var pwd = runpwd.stdout;
      var name = pwd.split('/mnt/c/Users/');
      name = name[1].trim();
      name = name.split('/');
      name = name[0].trim();
      return name;
    }

    get_threads() {
      var processors = SysInfo.processors;
      var threads = processors.length;
      threads = threads - 2;
      return threads;
    }

    install_1(download_link, file_extension) async {
      var username = await get_username();
      var threads = get_threads();
      var slash_part = '\\';
      var slash = '$slash_part$slash_part';
      await remove_file('/mnt/c/Users/$username/vmlinux.bin');
      await remove_file('/mnt/c/Users/$username/bzImage');
      await remove_file('/mnt/c/Users/$username/.wslconfig');
      await download_file(download_link, '/wsl2/kernel$file_extension');
      await shell
          .run('''tar -xf $path/wsl2/kernel$file_extension -C $path/wsl2/''');
      await download_file(
          'https://raw.githubusercontent.com/microsoft/WSL2-Linux-Kernel/linux-msft-wsl-5.10.y/Microsoft/config-wsl',
          '/wsl2/config-wsl');
      Directory.current = '$path/wsl2/';
      await shell.run(
          '''sudo apt-get install -y dwarves libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf''');
      await shell.run(
          '''sed -i 's+CONFIG_LOCALVERSION="-microsoft-standard-WSL2"+CONFIG_LOCALVERSION="-trident-WSL2"+gI' config-wsl''');
      await shell.run(
          '''mv $path/wsl2/config-wsl $path/wsl2/linux-$kernel_version/arch/x86/configs/wsl_defconfig''');
      Directory.current = '$path/wsl2/linux-$kernel_version/';
      await shell.run('''make wsl_defconfig''');
      await shell.run('''make -j$threads''');
      await shell.run(
          '''cp $path/wsl2/linux-$kernel_version/arch/x86/boot/bzImage /mnt/c/Users/$username''');
      await shell.run(
          '''cp $path/wsl2/linux-$kernel_version/arch/x86/boot/vmlinux.bin /mnt/c/Users/$username''');
      wrtite_catalog(
          '[wsl2]\r\nkernel=C:' +
              '$slash' +
              'Users' +
              '$slash' +
              '$username' +
              '$slash' +
              'bzImage',
          '/mnt/c/Users/$username/.wslconfig');
      var check1 = await file_status('/mnt/c/Users/$username/vmlinux.bin');
      var check1_status = check1[0];
      var check1_color = check1[1];
      var check2 = await file_status('/mnt/c/Users/$username/bzImage');
      var check2_status = check2[0];
      var check2_color = check2[1];
      var check3 = await file_status('/mnt/c/Users/$username/.wslconfig');
      var check3_status = check3[0];
      var check3_color = check3[1];
      print('[' +
          '$check1_color' +
          ' $check1_status ' +
          '\x1B[0m' +
          '] vmlinux.bin');
      print(
          '[' + '$check2_color' + ' $check2_status ' + '\x1B[0m' + '] bzImage');
      print('[' +
          '$check3_color' +
          ' $check3_status ' +
          '\x1B[0m' +
          '] .wslconfig');
      if (check1_status == 'OK') {
        if (check2_status == 'OK') {
          if (check3_status == 'OK') {
            print('Done building $kernel_version. Please reboot wsl');
          } else {
            print(error_7);
          }
        } else {
          print(error_7);
        }
      } else {
        print(error_7);
      }
    }

    if (kernel_type == 'RC') {
      String download_link =
          'https://git.kernel.org/torvalds/t/linux-$kernel_version.tar.gz';
      await install_1(download_link, '.tar.gz');
    } else {
      String download_link =
          'https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-$kernel_version.tar.xz';
      await install_1(download_link, '.tar.xz');
    }
  } else {
    print(error_5);
  }
}

Future<void> create_folder(folder) async {
  final pathexists = await Directory(folder).exists();
  if (pathexists == true) {
    await Directory(folder).delete(recursive: true);
    await Directory(folder).create(recursive: true);
  } else {
    await Directory(folder).create(recursive: true);
  }
}

Future<void> remove_file(file) async {
  final pathexists = await File(file).exists();
  if (pathexists == true) {
    await File(file).delete(recursive: true);
  }
}

Future file_status(file) async {
  final pathexists = await File(file).exists();
  var status = 'FAILED';
  var color = '\x1B[31m';
  if (pathexists == true) {
    status = 'OK';
    color = '\x1B[32m';
  }
  return [status, color];
}

installrc(kernel_version, kernel_type, VER_STR, VER_STAND) async {
  var status = await get_status(kernel_version);
  var status_amd64 = status[0];
  var status_arm64 = status[1];

  if (status_amd64 == 'failed') {
    status_amd64_bit = 0;
  }
  if (status_arm64 == 'failed') {
    status_arm64_bit = 0;
  }

  install_1(secretstr) async {
    if (status_amd64 == 'failed') {
      if (status_arm64 == 'failed') {
      } else if (status_amd64 == 'failed') {
        await download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-headers-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
                '_arm64.deb',
            '5arm.deb');
        await download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-image-unsigned-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
                '_arm64.deb',
            '6arm.deb');
        await download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-modules-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
                '_arm64.deb',
            '7arm.deb');
      }
    } else if (status_arm64 == 'failed') {
      if (status_amd64 == 'failed') {
      } else if (status_arm64 == 'failed') {
        await download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
                '_amd64.deb',
            '1amd.deb');
        await download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$VER_STAND-' +
                '$VER_STR' +
                '_$VER_STAND-$VER_STR.$secretstr' +
                '_all.deb',
            '2amd.deb');
        await download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-image-unsigned-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
                '_amd64.deb',
            '3amd.deb');
        await download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-modules-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
                '_amd64.deb',
            '4amd.deb');
      }
    } else {
      await download_file(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
              '_amd64.deb',
          '1amd.deb');
      await download_file(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$VER_STAND-' +
              '$VER_STR' +
              '_$VER_STAND-$VER_STR.$secretstr' +
              '_all.deb',
          '2amd.deb');
      await download_file(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-image-unsigned-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
              '_amd64.deb',
          '3amd.deb');
      await download_file(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-modules-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
              '_amd64.deb',
          '4amd.deb');
      await download_file(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-headers-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
              '_arm64.deb',
          '5arm.deb');
      await download_file(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-image-unsigned-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
              '_arm64.deb',
          '6arm.deb');
      await download_file(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-modules-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR.$secretstr' +
              '_arm64.deb',
          '7arm.deb');
    }
  }

  install_2() async {
    if (SysInfo.kernelArchitecture == 'x86_64') {
      await shell.run('''sudo dpkg -i *amd.deb''');
    } else if (SysInfo.kernelArchitecture == 'ARM') {
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

  if (VER_STR.endsWith('00')) {
    kernel_version = ('$kernel_version.0');
  }

  if (status_amd64 == 'failed') {
    status_amd64_bit = 0;
  }
  if (status_arm64 == 'failed') {
    status_arm64_bit = 0;
  }

  install_1(secretstr) async {
    if (status_amd64 == 'failed') {
      if (status_arm64 == 'failed') {
      } else if (status_amd64 == 'failed') {
        download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-headers-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_arm64.deb',
            '5arm.deb');
        download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-image-unsigned-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_arm64.deb',
            '6arm.deb');
        download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-modules-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_arm64.deb',
            '7arm.deb');
      }
    } else if (status_arm64 == 'failed') {
      if (status_amd64 == 'failed') {
      } else if (status_arm64 == 'failed') {
        download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_amd64.deb',
            '1amd.deb');
        download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$kernel_version-' +
                '$VER_STR' +
                '_$kernel_version-$VER_STR.$secretstr' +
                '_all.deb',
            '2amd.deb');
        download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-image-unsigned-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_amd64.deb',
            '3amd.deb');
        download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-modules-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_amd64.deb',
            '4amd.deb');
      }
    } else {
      download_file(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
              '_amd64.deb',
          '1amd.deb');
      download_file(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$kernel_version-' +
              '$VER_STR' +
              '_$kernel_version-$VER_STR.$secretstr' +
              '_all.deb',
          '2amd.deb');
      download_file(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-image-unsigned-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
              '_amd64.deb',
          '3amd.deb');
      download_file(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-modules-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
              '_amd64.deb',
          '4amd.deb');
      download_file(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-headers-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
              '_arm64.deb',
          '5arm.deb');
      download_file(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-image-unsigned-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
              '_arm64.deb',
          '6arm.deb');
      download_file(
          'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/arm64/linux-modules-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
              '_arm64.deb',
          '7arm.deb');
    }
  }

  install_2() async {
    String? secretstr = get_secretstr(
        'arm64/linux-headers-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR',
        kernel_version);
    print(secretstr);

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
