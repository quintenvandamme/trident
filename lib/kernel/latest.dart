import 'package:http/http.dart';
import 'package:Trident/gui/list.dart';

kernelbody() async {
  var url = Uri.parse('https://kernel.org/');
  var response = await get(url);
  return response.body.toString();
}

latest_rc_kernel() async {
  var kernel_body = await kernelbody();
  var latest_rc1 = kernel_body.split('''<table id="releases">
                <tr align="left">
            <td>mainline:</td>
            <td><strong>''');
  var latest_rc2 = latest_rc1[1].trim();
  var latest_rc3 = latest_rc2.split('</strong></td>');
  var latest_rc = latest_rc3[0].trim();
  if (latest_rc.contains('-rc')) {
  } else {
    var latest_mainline = await latest_mainline_kernel();
    print('The mainline kernel is newer. Using $latest_mainline.');
  }
  return latest_rc;
}

latest_rc_kernel_kernelubuntucom() async {
  List rc_ubuntu_list = await get_list_kernelubuntucom();
  return rc_ubuntu_list[
      rc_ubuntu_list.indexWhere((item) => item.contains('-rc'))];
}

latest_mainline_kernel() async {
  var kernel_body = await kernelbody();
  var latest_mainline1 = kernel_body.split('''<tr align="left">
            <td>stable:</td>
            <td><strong>''');
  var latest_mainline2 = latest_mainline1[1].trim();
  var latest_mainline3 = latest_mainline2.split('</strong></td>');
  var latest_mainline = latest_mainline3[0].trim();
  return latest_mainline;
}

latest_mainline_kernel_kernelubuntucom() async {
  List mainline_ubuntu_list = await get_list_kernelubuntucom();
  mainline_ubuntu_list.removeWhere((item) => item.contains('-rc'));
  mainline_ubuntu_list.removeWhere((item) => item.contains('5.15.'));
  return mainline_ubuntu_list[0];
}

latest_lts_kernel() async {
  var kernel_body = await kernelbody();
  var latest_lts1 = kernel_body.split('''<tr align="left">
            <td>longterm:</td>
            <td><strong>''');
  var latest_lts2 = latest_lts1[1].trim();
  var latest_lts3 = latest_lts2.split('</strong></td>');
  var latest_lts = latest_lts3[0].trim();
  return latest_lts;
}

latest_lts_kernel_kernelubuntucom() async {
  List lts_ubuntu_list = await get_list_kernelubuntucom();
  return lts_ubuntu_list[
      lts_ubuntu_list.indexWhere((item) => item.startsWith('5.15.'))];
}
