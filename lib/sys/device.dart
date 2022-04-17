import 'package:system_info2/system_info2.dart';
import 'package:Trident/install/rpi/main.dart'
    show bcmrpi, bcm2709, bcm271132, bcm271164, get_board_revision;

is_wsl() {
  if (SysInfo.kernelVersion.contains('WSL2'))
    return true;
  else
    return false;
}

is_wsa() {
  if (SysInfo.kernelVersion
      .contains('-windows-subsystem-for-android')) // to be seen
    return true;
  else
    return false;
}

is_rpi() async {
  try {
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
  } catch (error) {
    return false;
  }
}

is_apple_arm64() {
  if (SysInfo.cores[0].architecture == 'ARM64') if (SysInfo.cores[0].vendor ==
      'Apple')
    return true;
  else
    return false;
  else
    return false;
}

is_generic() async {
  if (is_wsl() == false && await is_rpi() == false)
    return true;
  else
    return false;
}

void main() async {
  print(await is_generic());
}
