import 'dart:io';
import 'package:Trident/web.dart';
import 'package:Trident/system.dart';
import 'package:Trident/file_handeler.dart';
import 'package:Trident/globals/error.dart';
import 'package:Trident/globals/path.dart';
import 'package:cli_dialog/cli_dialog.dart';
import 'package:system_info2/system_info2.dart';
import 'package:process_run/shell.dart';

var shell = Shell();

void install_wsl_x86_64(
    kernel_version, kernel_type, download_link, file_extension) async {
  String? system_kernel = SysInfo.kernelVersion;
  if (system_kernel.contains('-WSL2')) {
    system_kernel = system_kernel.replaceAll('-microsoft-standard-WSL2', '');
    void wrtite_catalog(str, file) {
      new File(file).writeAsStringSync(str, mode: FileMode.append);
    }

    install(download_link, file_extension) async {
      var username = await get_username();
      var threads = get_threads();
      var slash_part = '\\';
      var slash = '$slash_part$slash_part';
      print(download_link);
      await download_file(download_link, '/wsl2/kernel$file_extension');
      await shell.run(
          '''tar -xf $path_download/wsl2/kernel$file_extension -C $path_download/wsl2/''');
      await download_file(
          'https://raw.githubusercontent.com/microsoft/WSL2-Linux-Kernel/linux-msft-wsl-5.10.y/Microsoft/config-wsl',
          '/wsl2/config-wsl');
      Directory.current = '$path_download/wsl2/';
      await shell.run(
          '''sudo apt-get install -y dwarves libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf''');
      await shell.run(
          '''sed -i 's+CONFIG_LOCALVERSION="-microsoft-standard-WSL2"+CONFIG_LOCALVERSION="-trident-WSL2"+gI' config-wsl''');
      await shell.run(
          '''mv $path_download/wsl2/config-wsl $path_download/wsl2/linux-$kernel_version/arch/x86/configs/wsl_defconfig''');
      Directory.current = '$path_download/wsl2/linux-$kernel_version/';
      await shell.run('''make wsl_defconfig''');
      await shell.run('''make -j$threads''');
      await remove_file('/mnt/c/Users/$username/vmlinux.bin');
      await remove_file('/mnt/c/Users/$username/bzImage');
      await remove_file('/mnt/c/Users/$username/.wslconfig');
      await shell.run(
          '''cp $path_download/wsl2/linux-$kernel_version/arch/x86/boot/bzImage /mnt/c/Users/$username''');
      await shell.run(
          '''cp $path_download/wsl2/linux-$kernel_version/arch/x86/boot/vmlinux.bin /mnt/c/Users/$username''');
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

      switch (check1_status) {
        case "OK":
          {
            switch (check2_status) {
              case "OK":
                {
                  switch (check3_status) {
                    case "OK":
                      {
                        print('');

                        final dialog = CLI_Dialog(booleanQuestions: [
                          [
                            'Done building linux $kernel_version. Want to reboot WSL?',
                            'do_reboot'
                          ]
                        ]);
                        final answer = dialog.ask()['do_reboot'];
                        switch (answer) {
                          case true:
                            {
                              await shell.run('''wsl.exe --shutdown''');
                            }
                            break;
                        }
                      }
                      break;
                    default:
                      {
                        print(error_7);
                      }
                  }
                }
                break;
              default:
                {
                  print(error_7);
                }
            }
          }
          break;
        default:
          {
            print(error_7);
          }
      }
    }

    install(download_link, file_extension);
  } else {
    print(error_5);
  }
}

void install_wsl_rc_x86_64(kernel_version, kernel_type) async {
  String download_link =
      'https://git.kernel.org/torvalds/t/linux-$kernel_version.tar.gz';
  install_wsl_x86_64(kernel_version, kernel_type, download_link, '.tar.gz');
}

void install_wsl_mainline_x86_64(kernel_version, kernel_type) async {
  String download_link =
      'https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-$kernel_version.tar.xz';
  install_wsl_x86_64(kernel_version, kernel_type, download_link, '.tar.xz');
}