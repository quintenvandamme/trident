import 'package:Trident/web/main.dart';
import 'package:system_info2/system_info2.dart';

convert_kernel_toint(String kernel) {
  if (kernel.contains('-rc')) {
    kernel = kernel.substring(0, kernel.length - 1);
  }
  var kernel1 = kernel.replaceAll('-rc', '');
  if ('.'.allMatches(kernel1).length == 1) {
    var kernel2 = kernel1.replaceAll('.', '');
    var kernel3 = '$kernel2' + '000';
    return int.parse(kernel3);
  } else if ('.'.allMatches(kernel1).length == 2) {
    var kernel2 = kernel1.replaceAll('.', '');
    var kernel3 = '$kernel2' + '00';
    if (kernel3.length == 8) {
      // remove two last digits from kernel3 eg ( 5.10.102 becomes 510102 and not 5100200 )
      kernel3 = kernel3.substring(0, kernel3.length - 2);
    }
    return int.parse(kernel3);
  }
}

get_wsl_kernel_config_info() async {
  var content;
  var linuxstr;
  if (SysInfo.kernelArchitecture == 'x86_64') {
    content = await get_contents(
        'https://raw.githubusercontent.com/microsoft/WSL2-Linux-Kernel/linux-msft-wsl-5.10.y/Microsoft/config-wsl');
    linuxstr = 'x86';
  } else if (SysInfo.kernelArchitecture == 'ARM') {
    content = await get_contents(
        'https://raw.githubusercontent.com/microsoft/WSL2-Linux-Kernel/linux-msft-wsl-5.10.y/Microsoft/config-wsl-arm64');
    linuxstr = 'arm64';
  }
  List result = content.split('Kernel');
  var result2 = result[0];
  List result3 = result2.split('#');
  result3.removeAt(1);
  result3.removeAt(1);
  var result4 = result3.toString();
  var result5 = result4.replaceAll('Linux/$linuxstr', '');
  var result6 = result5.replaceAll('[,', '');
  var result7 = result6.replaceAll(' ]', '');
  var result8 = result7.replaceAll(' ', '');
  return result8.substring(0, result8.length - 2);
}
