import 'dart:io';
import 'package:Trident/web.dart';

void catalog_main(kernel_version, kernel_type, VER_STR, VER_STAND) {
  if (kernel_type == 'RC') {
    get_file(kernel_version).whenComplete(() {
      rc(kernel_version, kernel_type, VER_STR, VER_STAND);
    });
  } else {
    get_file(kernel_version).whenComplete(() {
      mainline(kernel_version, kernel_type, VER_STR, VER_STAND);
    });
  }
}

void rc(kernel_version, kernel_type, VER_STR, VER_STAND) async {
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

  if (status_amd64 == 'failed') {
    if (status_arm64 == 'failed') {
    } else if (status_amd64 == 'failed') {
      String? secretstr = get_secretstr(
          'arm64/linux-headers-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR',
          kernel_version);
      String scriptstring_rc = '$kernel_version' +
          '.' +
          '$status_amd64_bit' +
          '.' +
          '$status_arm64_bit' +
          '.' +
          '$secretstr\r';
      wrtite_catalog(scriptstring_rc);
    }
  } else if (status_arm64 == 'failed') {
    if (status_amd64 == 'failed') {
    } else if (status_arm64 == 'failed') {
      String? secretstr = get_secretstr(
          'amd64/linux-headers-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR',
          kernel_version);
      String scriptstring_rc = '$kernel_version' +
          '.' +
          '$status_amd64_bit' +
          '.' +
          '$status_arm64_bit' +
          '.' +
          '$secretstr\r';
      wrtite_catalog(scriptstring_rc);
    }
  } else {
    String? secretstr = get_secretstr(
        'amd64/linux-headers-$VER_STAND-$VER_STR-generic_$VER_STAND-$VER_STR',
        kernel_version);
    String scriptstring_rc = '$kernel_version' +
        '.' +
        '$status_amd64_bit' +
        '.' +
        '$status_arm64_bit' +
        '.' +
        '$secretstr\r';
    wrtite_catalog(scriptstring_rc);
  }
}

void mainline(kernel_version, kernel_type, VER_STR, VER_STAND) async {
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

  if (status_amd64 == 'failed') {
    if (status_arm64 == 'failed') {
    } else if (status_amd64 == 'failed') {
      String? secretstr = get_secretstr(
          'arm64/linux-headers-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR',
          kernel_version);
      String scriptstring_mainline = '$kernel_version' +
          '.' +
          '$status_amd64_bit' +
          '.' +
          '$status_arm64_bit' +
          '.' +
          '$secretstr\r';
      wrtite_catalog(scriptstring_mainline);
    }
  } else if (status_arm64 == 'failed') {
    if (status_amd64 == 'failed') {
    } else if (status_arm64 == 'failed') {
      String? secretstr = get_secretstr(
          'amd64/linux-headers-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR',
          kernel_version);
      String scriptstring_mainline = '$kernel_version' +
          '.' +
          '$status_amd64_bit' +
          '.' +
          '$status_arm64_bit' +
          '.' +
          '$secretstr\r';
      wrtite_catalog(scriptstring_mainline);
    }
  } else {
    String? secretstr = get_secretstr(
        'amd64/linux-headers-$kernel_version-$VER_STR-generic_$kernel_version-$VER_STR',
        kernel_version);
    String scriptstring_mainline = '$kernel_version' +
        '.' +
        '$status_amd64_bit' +
        '.' +
        '$status_arm64_bit' +
        '.' +
        '$secretstr\r';
    wrtite_catalog(scriptstring_mainline);
  }
}

wrtite_catalog(str) {
  final script_name = '/var/cache/trident/list.text';
  new File(script_name).writeAsStringSync(str, mode: FileMode.append);
}
