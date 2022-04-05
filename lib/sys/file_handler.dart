import 'dart:io';
import 'package:Trident/globals/path.dart';
import 'package:process_run/shell.dart';
import 'package:system_info2/system_info2.dart';

var shell = Shell();

Future<void> create_folder(folder, reset) async {
  final path_downloadexists_final = await Directory(folder).exists();
  String path_downloadexists = '$path_downloadexists_final';
  switch (reset) {
    case "true":
      {
        switch (path_downloadexists) {
          case "true":
            {
              await Directory(folder).delete(recursive: true);
              await Directory(folder).create(recursive: true);
            }
            break;
          default:
            {
              await Directory(folder).create(recursive: true);
            }
            break;
        }
      }
      break;
    default:
      {
        switch (path_downloadexists) {
          case "false":
            {
              var user = SysInfo.userName;
              await Directory(folder).create(recursive: true);
              await shell.run('''sudo chown $user:$user $path''');
            }
            break;
        }
      }
      break;
  }
}

Future<void> remove_file(file) async {
  final path_downloadexists_final = await File(file).exists();
  String path_downloadexists = '$path_downloadexists_final';
  switch (path_downloadexists) {
    case "true":
      {
        await File(file).delete(recursive: true);
      }
      break;
  }
}

Future<void> remove_file_root(file) async {
  final path_downloadexists_final = await File(file).exists();
  String path_downloadexists = '$path_downloadexists_final';
  switch (path_downloadexists) {
    case "true":
      {
        await shell.run('''sudo rm $file''');
      }
      break;
  }
}

Future file_status(file) async {
  final path_downloadexists = await File(file).exists();
  var status = 'FAILED';
  var color = '\x1B[31m';
  if (path_downloadexists == true) {
    status = 'OK';
    color = '\x1B[32m';
  }
  return [status, color];
}
