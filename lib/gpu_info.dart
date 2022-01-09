import 'dart:io';

get_gpuinfo() async {
  var info = await Process.run(
    'lshw',
    ['-C', 'display'],
  );
  var gpuinfo = info.stdout;
  if (gpuinfo.contains('nvidia')) {
    return 1;
  } else if (gpuinfo.contains('Nvidia')) {
    return 1;
  } else {
    return 0;
  }
}
