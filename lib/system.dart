import 'dart:io';
import 'package:system_info2/system_info2.dart';
import 'package:process_run/shell.dart';

var shell = Shell();

get_username() async {
  Directory.current = '/mnt/c/Users/';
  var name1 = await Process.run(
    'ls',
    ['-1t'],
  );
  var name2 = name1.stdout;
  var name3 = name2.split('\n');
  var username = name3[0].trim();
  return username;
}

get_threads() {
  var processors = SysInfo.cores;
  var threads = processors.length;
  threads = threads - 2;
  return threads;
}

get_gpuinfo() async {
  var info = await Process.run(
    'lshw',
    ['-C', 'display'],
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
