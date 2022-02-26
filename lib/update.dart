import 'package:cli_dialog/cli_dialog.dart';
import 'package:Trident/web.dart';
import 'package:Trident/file_handeler.dart';
import 'package:Trident/globals/path.dart';
import 'package:Trident/globals/package_info.dart';
import 'package:process_run/shell.dart';

checkforupdate() async {
  String latestrelease = await get_latestrelease(repo);
  String trident_version_stand = trident_version;
  trident_version = '$trident_version$trident_prerelease_version';
  switch (trident_version.contains('rc')) {
    case true:
      {
        trident_version_stand =
            trident_version.substring(0, trident_version.length - 4);
        String trident_version_stand_convert =
            trident_version_stand.replaceAll(".", '');
        String latestrelease_convert = latestrelease.replaceAll(".", '');
        String latestrelease_stand_convert = latestrelease_convert.substring(
            0, latestrelease_convert.length - 4);
        var checkversion = trident_version_stand_convert
            .compareTo(latestrelease_stand_convert);
        switch (checkversion) {
          case 0:
            {
              var checkrcnumber_trident_version1 = trident_version.split('-rc');
              var checkrcnumber_trident_version =
                  checkrcnumber_trident_version1[1].trim();
              var checkrcnumber_latestrelease1 = latestrelease.split('-rc');
              var checkrcnumber_latestrelease =
                  checkrcnumber_latestrelease1[1].trim();
              var checkrcversion = checkrcnumber_trident_version
                  .compareTo(checkrcnumber_latestrelease);

              switch (checkrcversion) {
                case 1:
                  {
                    return 0;
                  }

                case 0:
                  {
                    return 0;
                  }

                default:
                  {
                    return 1;
                  }
              }
            }

          case 1:
            {
              return 0;
            }

          default:
            {
              return 1;
            }
        }
      }
    default:
      {
        String latestrelease_convert1 = latestrelease.replaceAll(".", '');
        var latestrelease_convert2 = latestrelease_convert1.split('-rc');
        var latestrelease_convert = latestrelease_convert2[0].trim();
        String trident_version_convert = trident_version.replaceAll(".", '');
        var checkversion =
            trident_version_convert.compareTo(latestrelease_convert);
        switch (checkversion) {
          case 0:
            {
              switch (latestrelease.contains('rc')) {
                case true:
                  {
                    return 0;
                  }

                default:
                  {
                    return 1;
                  }
              }
            }
          case 1:
            {
              return 0;
            }

          default:
            {
              return 1;
            }
        }
      }
  }
}

prompt_update() {
  final dialog = CLI_Dialog(booleanQuestions: [
    [
      'A new version of trident is available. Do you want to update?',
      'do_update'
    ]
  ]);
  final answer = dialog.ask()['do_update'];
  return answer;
}

update() async {
  trident_version = '$trident_version$trident_prerelease_version';
  var shell = Shell();
  String latestrelease = await get_latestrelease(repo);
  await download_file(
      'https://github.com/quintenvandamme/trident/releases/download/$latestrelease/trident',
      'trident');
  await remove_file_root('/usr/bin/trident');
  await shell.run('''sudo cp $path_download/trident /usr/bin/''');
  await shell.run('''sudo chmod +x /usr/bin/trident''');
  print('Updated trident from $trident_version to $latestrelease');
}
