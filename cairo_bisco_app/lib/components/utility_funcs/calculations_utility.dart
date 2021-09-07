double parseJsonToDouble(dynamic dAmount) {
  double returnAmount = 0.00;
  String strAmount;

  try {
    if (dAmount == null || dAmount == 0) return 0.0;

    strAmount = dAmount.toString();

    // if (strAmount.contains('.')) {
    returnAmount = double.parse(strAmount);
    //} // Didn't need else since the input was either 0, an integer or a double
  } catch (e) {
    print('Error :: exception caught during json parse');
    return 0.000;
  }

  return returnAmount;
}
