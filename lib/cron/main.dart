import 'package:cron/cron.dart';
import 'package:Trident/kernel/latest.dart';
import 'package:Trident/kernel/main.dart';
import 'package:Trident/sys/config.dart';
import 'package:system_info2/system_info2.dart';

check_for_new_kernel() async {
  final cron = Cron();
  var system_kernel = SysInfo.kernelVersion;
  if (system_kernel.contains('-trident-WSL2')) {
    system_kernel = SysInfo.kernelVersion.replaceAll('-trident-WSL2', '');
  } else if (system_kernel.contains('-microsoft-standard-WSL2')) {
    system_kernel =
        SysInfo.kernelVersion.replaceAll('-microsoft-standard-WSL2', '');
  }
  // configs
  var cron_schedule = null;
  var cron_checkfor = null;
  try {
    cron_schedule = await get_config('cron_schedule');
  } catch (error) {}
  try {
    cron_checkfor = await get_config('cron_checkfor');
  } catch (error) {}
  switch (cron_checkfor) {
    case 'latest_rc':
      {
        cron.schedule(Schedule.parse(cron_schedule), () async {
          if (convert_kernel_toint(await latest_rc_kernel()) >
              convert_kernel_toint(system_kernel)) {
            return true;
          } else {
            return false;
          }
        });
      }
      break;
    case 'latest_lts':
      {
        cron.schedule(Schedule.parse(cron_schedule), () async {
          if (convert_kernel_toint(await latest_lts_kernel()) >
              convert_kernel_toint(system_kernel)) {
            return true;
          } else {
            return false;
          }
        });
      }
      break;
    case 'latest_mainline':
      {
        cron.schedule(Schedule.parse(cron_schedule), () async {
          if (convert_kernel_toint(await latest_mainline_kernel()) >
              convert_kernel_toint(system_kernel)) {
            return true;
          } else {
            return false;
          }
        });
      }
      break;
  }
}
