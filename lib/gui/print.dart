import 'package:Trident/kernel/latest.dart';

// debug only

void main() async {
  print('------------kernel.org------------');
  print('rc: ${await latest_rc_kernel()}');
  print('mainline: ${await latest_mainline_kernel()}');
  print('lts: ${await latest_lts_kernel()}');
  print('--------kernel.ubuntu.com---------');
  print('rc: ${await latest_rc_kernel_kernelubuntucom()}');
  print('mainline: ${await latest_mainline_kernel_kernelubuntucom()}');
  print('lts: ${await latest_lts_kernel_kernelubuntucom()}');
}
