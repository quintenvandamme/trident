import 'dart:io';
import 'package:Trident/web/main.dart';
import 'package:Trident/sys/system.dart';
import 'package:Trident/globals/error.dart';
import 'package:Trident/globals/path.dart';
import 'package:process_run/shell.dart';
import 'package:system_info2/system_info2.dart';

var shell = new Shell(runInShell: true);

installrc_x86_64(
    kernel_version, kernel_type, VER_STR, VER_STAND, secretstr) async {
  var status = await get_status(kernel_version);
  var status_amd64 = status[0];
  switch (status_amd64) {
    case "success":
      {
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
        Directory.current = '$path_download';
        await shell.run('''sudo dpkg -i 1amd.deb''');
        await shell.run('''sudo dpkg -i 2amd.deb''');
        await shell.run('''sudo dpkg -i 3amd.deb''');
        await shell.run('''sudo dpkg -i 4amd.deb''');
      }
      break;

    default:
      {
        print(error_11);
      }
      break;
  }
}

installmainline_x86_64(
    kernel_version, kernel_type, VER_STR, VER_STAND, secretstr) async {
  var status = await get_status(kernel_version);
  var status_amd64 = status[0];
  switch (status_amd64) {
    case "success":
      {
        await download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_amd64.deb',
            '1amd.deb');
        await download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-headers-$kernel_version-' +
                '$VER_STR' +
                '_$kernel_version-$VER_STR.$secretstr' +
                '_all.deb',
            '2amd.deb');
        await download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-image-unsigned-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_amd64.deb',
            '3amd.deb');
        await download_file(
            'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/amd64/linux-modules-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR.$secretstr' +
                '_amd64.deb',
            '4amd.deb');
        Directory.current = '$path_download';
        await shell.run('''sudo dpkg -i 1amd.deb''');
        await shell.run('''sudo dpkg -i 2amd.deb''');
        await shell.run('''sudo dpkg -i 3amd.deb''');
        await shell.run('''sudo dpkg -i 4amd.deb''');
      }
      break;

    default:
      {
        print(error_11);
      }
      break;
  }
}

void compile_main_x86_64(kernel_version, kernel_type) async {
  install_1(download_link, file_extension) async {
    var threads = get_threads();
    String? system_kernel = SysInfo.kernelVersion;
    await download_file(download_link, '/linux/kernel$file_extension');
    await shell.run(
        '''tar -xf $path_download/linux/kernel$file_extension -C $path_download/linux/''');
    Directory.current = '$path_download/linux/';
    await shell.run(
        '''sudo apt-get install -y dwarves libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf''');
    Directory.current = '$path_download/linux/linux-$kernel_version/';
    await shell.run('''sudo cp /boot/config-$system_kernel ./.config''');
    await shell.run(
        '''sed -i 's+CONFIG_SYSTEM_TRUSTED_KEYS="debian/canonical-certs.pem"+CONFIG_SYSTEM_TRUSTED_KEYS=""+gI' ./.config''');
    await shell.run(
        '''sed -i 's+CONFIG_SYSTEM_REVOCATION_KEYS="debian/canonical-revoked-certs.pem"+CONFIG_SYSTEM_REVOCATION_KEYS=""+gI' ./.config''');
    await shell.run(
        '''sed -i 's+CONFIG_LOCALVERSION=""+CONFIG_LOCALVERSION="-trident"+gI' ./.config''');
    await shell.run(
        '''sed -i 's+bool+ +gI' $path_download/linux/linux-$kernel_version/init/Kconfig''');
    await shell.run('''make -j$threads''');
    await shell.run('''sudo make modules_install''');
    await shell.run('''sudo make install''');
    print('Done building linux $kernel_version. Please reboot your system');
  }

  compile_rc(kernel_version, kernel_type) async {
    String download_link =
        'https://git.kernel.org/torvalds/t/linux-$kernel_version.tar.gz';
    await install_1(download_link, '.tar.gz');
  }

  compile_mainline(kernel_version, kernel_type) async {
    String download_link =
        'https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-$kernel_version.tar.xz';
    await install_1(download_link, '.tar.xz');
  }

  if (kernel_type == 'RC') {
    await compile_rc(kernel_version, kernel_type);
  } else {
    await compile_mainline(kernel_version, kernel_type);
  }
}
