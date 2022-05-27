import 'dart:io';
import 'dart:convert';
import 'package:Trident/globals/path.dart';

class config {
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

  checkforupdates() async {
    var checkforupdates = true;
    try {
      checkforupdates = await get_config('checkforupdates');
    } catch (error) {}
    return checkforupdates;
  }

  cron_schedule() async {
    var cron_schedule;
    try {
      cron_schedule = await get_config('cron_schedule');
    } catch (error) {}
    return cron_schedule;
  }

  cron_checkfor() async {
    var cron_checkfor;
    try {
      cron_checkfor = await get_config('cron_checkfor');
    } catch (error) {}
    return cron_checkfor;
  }
}
