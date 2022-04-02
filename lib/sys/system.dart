import 'dart:io';
import 'package:Trident/globals/error.dart';
import 'package:system_info2/system_info2.dart';
import 'package:process_run/shell.dart';
import 'package:Trident/sys/device.dart';

var shell = Shell();

get_username() async {
  var get_username = await Process.run(
    'wslvar',
    ['USERNAME'],
  );
  var username = get_username.stdout;
  return username.replaceAll("\n", "");
}

get_threads() {
  var processors = SysInfo.cores;
  var threads = processors.length;
  if (is_rpi == true) {
    threads = threads - 1;
  } else {
    if (threads == 2) {
      threads = threads - 1;
    } else if (threads < 2) {
      print(error_13);
      exit(0);
    } else {
      threads = threads - 2;
    }
  }
  return threads;
}

get_gpuinfo() async {
  var info = await Process.run(
    'lspci',
    [''],
  );
  var gpuinfo = info.stdout;

  switch (gpuinfo.contains('nvidia')) {
    case true:
      {
        return true;
      }
    default:
      {
        switch (gpuinfo.contains('Nvidia')) {
          case true:
            {
              return true;
            }
          default:
            {
              return false;
            }
        }
      }
  }
}
