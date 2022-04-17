import 'dart:io';
import 'package:Trident/globals/error.dart';
import 'package:Trident/web/main.dart';
import 'package:Trident/gui/list.dart';

get_version() {
  stdout.write("Kernel version: ");
  String? kernel_version = stdin.readLineSync();
  valid('https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/',
      kernel_version);
  if (kernel_version == null) {
    print(error_3);
    get_version();
  } else if (kernel_version == "") {
    print(error_3);
    get_version();
  }
  return kernel_version;
}

get_type(kernel_version) {
  if ('.'.allMatches(kernel_version).length == 1) {
    kernel_version = '$kernel_version.0';
  }

  if (kernel_version.contains('-rc')) {
    return 'RC';
  } else if (get_list_lts_kernels(true).contains(
      '${kernel_version.substring(0, kernel_version.indexOf(".", kernel_version.indexOf(".") + 1))}.')) {
    return 'LTS';
  } else {
    return 'MAINLINE';
  }
}

get_versionstring(kernel_version, kernel_type) {
  var VER_STR = kernel_version.replaceAll(new RegExp(r'[^\w\s]+'), '');

  switch (kernel_type) {
    case "RC":
      {
        VER_STR = VER_STR.substring(0, 3) +
            "00" +
            VER_STR.substring(3, VER_STR.length);
        VER_STR = '0$VER_STR';
        return VER_STR;
      }
    default:
      {
        switch (VER_STR.length) {
          case 5:
            {
              VER_STR = '0$VER_STR';
              return VER_STR;
            }
          case 4:
            {
              VER_STR = VER_STR.substring(0, 3) +
                  "0" +
                  VER_STR.substring(3, VER_STR.length);
              VER_STR = '0$VER_STR';
              return VER_STR;
            }
          case 3:
            {
              switch (kernel_version.length) {
                case 4:
                  {
                    switch (kernel_version.endsWith) {
                      case ".":
                        {
                          print(error_3);
                        }
                        break;
                      default:
                        {
                          VER_STR = VER_STR.substring(0, 3) +
                              "00" +
                              VER_STR.substring(3, VER_STR.length);
                          VER_STR = '0$VER_STR';
                          return VER_STR;
                        }
                    }
                  }
              }
            }
        }
      }
  }
}

get_versionstandalone(kernel_version, kernel_type) {
  if (kernel_type == 'RC') {
    var VER_STAND = kernel_version.substring(0, 4) +
        ".0" +
        kernel_version.substring(8, kernel_version.length);
    return VER_STAND;
  }
}
