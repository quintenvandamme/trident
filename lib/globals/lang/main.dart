import 'package:Trident/globals/error.dart';
import 'package:Trident/globals/lang/en.dart';
import 'package:Trident/globals/lang/nl.dart';

lang_global_str(str) {
  var lang = 'nl';
  if (lang == 'nl') {
  } else {
    return str;
  }
}

void main() {
  print(lang_global_str('error_1'));
}
