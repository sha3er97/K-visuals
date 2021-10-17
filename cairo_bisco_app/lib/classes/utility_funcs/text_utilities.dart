import 'package:flutter/foundation.dart' show kIsWeb;

bool emptyField(String val) {
  return val.trim().isEmpty;
}

bool isNotPercent(String val) {
  return double.parse(val).abs() > 100.0;
}

bool conditionalEmptyField(int count, String val) {
  if (count > 0) return val.trim().isEmpty;
  return false; //if count == 0
}

String reverseIfNecessary(String input) {
  if (kIsWeb) {
    // running on the web!
    return new String.fromCharCodes(input.runes.toList().reversed);
  } else {
    // NOT running on the web! You can check for additional platforms here.
    return input;
  }
}
