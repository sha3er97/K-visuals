class Credentials {
  static String plt_email = "";
  static String plt_password = "";
  static String screen_email = "";
  static String screen_password = "";
  static String admin_email = "";
  static String admin_password = "";
}

class Plans {
  static double targetOverWeightAbove = 0.1;
  static double targetOverWeightBelow = -0.1; //TODO :: remove
  static double targetOEE = 20.0;
  static double targetFilmWaste = 1.0; //TODO :: per sku
  static double targetScrap = 1.0; //TODO :: per sku
  static double mediumRisksBoundary = 5;
  static double highRisksBoundary = 12;
  static double scrapKgCost = 10.5;
}
