import 'dart:io';
import 'package:Trident/globals/error.dart';
import 'package:Trident/web.dart';

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
  if (kernel_version.startsWith('5.4.')) {
    String kernel_type = 'LTS';
    return kernel_type;
  } else if (kernel_version.startsWith('5.10.')) {
    String kernel_type = 'LTS';
    return kernel_type;
  } else if (kernel_version.startsWith('5.15.')) {
    String kernel_type = 'LTS';
    return kernel_type;
  } else if (kernel_version.contains('-rc')) {
    String kernel_type = 'RC';
    return kernel_type;
  } else {
    String kernel_type = 'MAINLINE';
    return kernel_type;
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
