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
  var get_config = new config();
  var cron_schedule = get_config.cron_schedule();
  var cron_checkfor = get_config.cron_checkfor();

  // cleanup code (patch by github.com/larsb24)
  cron.schedule(Schedule.parse(cron_schedule), () async {
    switch (cron_checkfor) {
      case 'latest_rc':
        return (convert_kernel_toint(await latest_rc_kernel()) >
            convert_kernel_toint(system_kernel));
      case 'latest_lts':
        return (convert_kernel_toint(await latest_lts_kernel()) >
            convert_kernel_toint(system_kernel));
      case 'latest_mainline':
        return (convert_kernel_toint(await latest_mainline_kernel()) >
            convert_kernel_toint(system_kernel));
    }
  });
}
