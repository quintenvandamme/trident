import 'package:system_info2/system_info2.dart';
import 'package:Trident/install/rpi/main.dart'
    show bcmrpi, bcm2709, bcm271132, bcm271164, get_board_revision;

is_wsl() {
  if (SysInfo.kernelVersion.contains('WSL2'))
    return true;
  else
    return false;
}

is_rpi() async {
  final String? board = await get_board_revision();
  if (bcmrpi.contains(board))
    return true;
  else if (bcm2709.contains(board))
    return true;
  else if (bcm271132.contains(board))
    return true;
  else if (bcm271164.contains(board))
    return true;
  else
    return false;
}
