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
