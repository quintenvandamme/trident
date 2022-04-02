import 'package:http/http.dart';

get_contents(url) async {
  var address = Uri.parse(url);
  var response = await get(address);
  return response.body.toString();
}

void get_list_kernelorg_rc() async {
  var contents = await get_contents(
      'https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/refs/');
  List result = contents.split('<a');
  result.removeWhere((item) => item.contains('link'));
  result.removeWhere((item) => item.contains('meta'));
  result.removeWhere((item) => item.contains('body'));
  result.removeWhere((item) => item.contains('head'));
  result.removeWhere((item) => item.contains('title'));
  result.removeWhere((item) => item.contains('option'));
  result.removeWhere((item) => item.contains('select'));
  result.removeWhere((item) => item.contains('form'));
  result.removeWhere((item) => item.contains('input'));

  convert_result() sync* {
    for (var prop in result) {
      var currentElement = prop;
      var testo = currentElement.replaceAll(
          RegExp(" href='/pub/scm/linux/kernel/git/torvalds/linux.git/tag/"),
          "");
      var testo1 = testo.replaceAll("\?h=v", "");
      var testo2 = testo1.replaceAll(RegExp(r"\'[^]*"), "");
      yield testo2;
    }
  }

  var converted_result = await convert_result();
  List result2 = converted_result.toList();
  result2.removeWhere((item) => item.contains('href'));
  result2.removeWhere((item) => item.contains('class'));
  print(result2);
}

void get_list_kernelorg_main() async {
  var contents =
      await get_contents('https://cdn.kernel.org/pub/linux/kernel/v5.x/');
  List result = contents.split('<a');
  result.removeWhere((item) => item.contains('patch'));
  result.removeWhere((item) => item.contains('ChangeLog'));
  result.removeWhere((item) => item.contains('sha'));
  result.removeWhere((item) => item.contains('html'));
  result.removeWhere((item) => item.contains('sign'));

  convert_result() sync* {
    for (var prop in result) {
      var currentElement = prop;
      var testo = currentElement.replaceAll(RegExp(r'^[^"]*"|"[^"]*$'), "");
      var testo1 = testo.replaceAll(RegExp('linux-'), "");
      var testo2 = testo1.replaceAll(RegExp('.tar.xz'), "");
      var testo3 = testo2.replaceAll(RegExp('.tar.gz'), "");
      yield testo3;
    }
  }

  var converted_result = await convert_result();
  List result2 = converted_result.toList();
  result2.removeWhere((item) => item.contains('/'));
  var result3 = result2.toSet().toList();
  print(result3);
}

void get_list_kernelubuntucom() async {
  var contents =
      await get_contents('https://kernel.ubuntu.com/~kernel-ppa/mainline/');
  List result = contents.split('<a');
  result.removeWhere((item) => item.contains('<tr><th'));
  result.removeWhere((item) => item.contains('title'));
  result.removeWhere((item) => item.contains('head'));
  result.removeWhere((item) => item.contains('html'));
  result.removeWhere((item) => item.contains('table'));
  result.removeWhere((item) => item.contains('drm'));
  result.removeWhere((item) => item.contains('trusty'));
  result.removeWhere((item) => item.contains('precise'));
  result.removeWhere((item) => item.contains('wily'));
  result.removeWhere((item) => item.contains('yakkety'));
  result.removeWhere((item) => item.contains('xenial'));
  result.removeWhere((item) => item.contains('queue'));
  result.removeWhere((item) => item.contains('.y.z'));
  result.removeWhere((item) => item.contains('C='));
  result.removeWhere((item) => item.contains('~kernel-ppa'));
  result.removeWhere((item) => item.contains('yaml'));
  result.removeWhere((item) => item.contains('daily'));
  convert_result() sync* {
    for (var prop in result) {
      var currentElement = prop;
      var testo = currentElement.replaceAll(RegExp('valign'), "");
      var testo1 = testo.replaceAll(RegExp(' href='), "");
      var testo2 = testo1.replaceAll(RegExp(r"\>[^]*"), "");
      var testo3 = testo2.replaceAll(RegExp('"'), "");
      var testo4 = testo3.replaceAll(RegExp('v'), "");
      var testo5 = testo4.replaceAll(RegExp('/'), "");
      yield testo5;
    }
  }

  var converted_result = await convert_result();
  List result2 = converted_result.toList();
  result2.removeWhere((item) => item.contains('A'));
  result2.removeWhere((item) => item.contains('B'));
  result2.removeWhere((item) => item.contains('C'));
  result2.removeWhere((item) => item.contains('X'));
  var result3 = new List.from(result2.reversed);

  print(result3);
}

void main() async {
  get_list_kernelubuntucom();
}