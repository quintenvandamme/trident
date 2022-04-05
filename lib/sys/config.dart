import 'dart:io';
import 'dart:convert';
import 'package:Trident/globals/path.dart';

Future get_config(conf) async {
  final configFile = File('$home/.config/trident/config.json');
  final jsonString = await configFile.readAsString();
  final dynamic jsonMap = jsonDecode(jsonString);
  var config = jsonMap[conf];
  if (config == 'true') {
    return true;
  } else if (config == 'false') {
    return false;
  }
}

void main() async {
  var checkforupdates = 'true';
  try {
    checkforupdates = await get_config('checkforupdates');
  } catch (error) {}
  print(checkforupdates);
}
