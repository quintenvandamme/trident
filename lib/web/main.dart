import 'dart:io';
import 'dart:core';
import 'package:Trident/globals/error.dart';
import 'package:Trident/globals/path.dart';
import 'package:Trident/version.dart';
import 'package:http/http.dart';

get_contents(url) async {
  var address = Uri.parse(url);
  var response = await get(address);
  return response.body.toString();
}

get_contents_kernelubuntu(kernel_version) async {
  var url = Uri.parse(
      'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/');
  var response = await get(url);
  return response.body.toString();
}

get_link(link_content, kernel_version) async {
  String contents = await get_contents_kernelubuntu(kernel_version);
  var parts = contents.split(link_content);
  var link_after_part = parts[1].trim();
  link_after_part = link_after_part.replaceAll('">', '');
  return 'https://kernel.ubuntu.com/~kernel-ppa/mainline/v$kernel_version/$link_content$link_after_part';
}

get_secretstr(link_content, kernel_version) async {
  String contents = await get_contents_kernelubuntu(kernel_version);
  var parts = contents.split(link_content);
  var link_after_part = parts[1].trim();
  link_after_part = link_after_part.replaceAll('">', '');
  var list = link_after_part.split('_');
  var secretstr = list[0].trim();
  return secretstr.replaceAll('.', '');
}

get_latestrelease(repo) async {
  var url = Uri.parse('https://api.github.com/repos/$repo/releases');
  var response = await get(url);
  String? responsetostr = response.body.toString();
  var getlatestrelease_1 =
      responsetostr.split('"html_url":"https://github.com/$repo/releases/tag/');
  var getlatestrelease_2 = getlatestrelease_1[1].trim();
  var getlatestrelease_3 = getlatestrelease_2.split('","');
  return getlatestrelease_3[0].trim();
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
    switch (response.statusCode) {
      case 200:
        {}
        break;
      default:
        {
          String error_4_message =
              error_4.replaceAll("%kernel", kernel_version);
          print(error_4_message);
          get_version();
        }
    }
  } catch (error) {
    get_version();
  }
}

download_file(url, name) async {
  Response response = await get(Uri.parse(url));
  File file = File('$path_download/$name');
  file.writeAsBytes(response.bodyBytes);
}
