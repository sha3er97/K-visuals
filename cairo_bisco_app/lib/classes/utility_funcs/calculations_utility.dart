import 'dart:math';

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

double calculateMPSA(int plan, int cartons) {
  if (cartons == 0) return 0.0;
  // return ((plan - cartons).abs().toDouble() * 100) / max(plan, cartons);
  return (min(plan, cartons).toDouble() * 100) / max(plan, cartons);
}
