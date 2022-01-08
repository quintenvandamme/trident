import 'dart:io';
import 'dart:core';
import 'package:Trident/globals/error.dart';
import 'package:Trident/version.dart';
import 'package:Trident/install.dart';
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
  var list = link_after_part.split('_');
  var secretstr = list[0].trim();
  secretstr = secretstr.replaceAll('.', '');
  return secretstr;
}

Future<List> get_status(kernel_version) async {
  var url = Uri.parse(
      'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/');
  var response = await get(url);
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
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
    } else {
      String error_4_message = error_4.replaceAll("%kernel", kernel_version);
      print(error_4_message);
      get_version();
    }
  } catch (error) {
    get_version();
  }
}

download_file(url, name) async {
  Response response = await get(Uri.parse(url));
  File file = File('$path/$name');
  file.writeAsBytes(response.bodyBytes);
}
