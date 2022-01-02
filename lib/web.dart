import 'dart:io';
import 'dart:core';
import 'package:Trident/version.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

String PULL_FILE = '/var/cache/trident/pull_file.txt';

get_file(kernel_version) async {
  final request = await HttpClient().getUrl(Uri.parse(
      'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/'));
  final response = await request.close();
  await response.pipe(File(PULL_FILE).openWrite());
}

get_link(link_content, kernel_version) {
  String contents = new File(PULL_FILE).readAsStringSync();
  var parts = contents.split(link_content);
  var link_after_part = parts[1].trim();
  link_after_part = link_after_part.replaceAll('">', '');
  String link =
      'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/$link_content$link_after_part';
  return link;
}

get_secretstr(link_content, kernel_version) {
  String contents = new File(PULL_FILE).readAsStringSync();
  var parts = contents.split(link_content);
  var link_after_part = parts[1].trim();
  link_after_part = link_after_part.replaceAll('">', '');
  var thestr = link_after_part.split('_');
  var thestr2 = thestr[0].trim();
  thestr2 = thestr2.replaceAll('.', '');
  String link =
      'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/$link_content$link_after_part';
  return thestr2;
}

Future<List> get_status(kernel_version) async {
  var url = Uri.parse(
      'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/');
  var response = await http.get(url);
  String amd64_status = 'success';
  String arm64_status = 'success';

  if (response.body.toString().contains('amd64/build failed')) {
    amd64_status = 'failed';
  } else if (response.body.toString().contains('arm64/build failed')) {
    arm64_status = 'failed';
  }
  return [amd64_status, arm64_status];
}

Future<void> valid(url, kernel_version) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
    } else {
      print('$kernel_version not found on kernel.ubuntu.com try another one.');
      get_version();
    }
  } catch (error) {
    get_version();
  }
}

download_deb(url, name) async {
  Response response = await get(Uri.parse(url));
  File file = File('/tmp/tridentdownloadcache/$name');
  file.writeAsBytes(response.bodyBytes);
}