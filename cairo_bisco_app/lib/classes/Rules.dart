import 'package:cloud_firestore/cloud_firestore.dart';

class Credentials {
  static String plt_email = "";
  static String plt_password = "";
  static String screen_email = ""; //screen@kelloggs.com
  static String screen_password = "";
  static String admin_email = "";
  static String admin_password = "";

  static void getCredentials() {
    FirebaseFirestore.instance
        .collection('Rules')
        .doc('users_credentials')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('getCredentials data: ${documentSnapshot.data()}');
        Credentials.plt_email = documentSnapshot["plt_email"];
        Credentials.plt_password = documentSnapshot["plt_password"];
        Credentials.screen_email = documentSnapshot["screen_email"];
        Credentials.screen_password = documentSnapshot["screen_password"];
        Credentials.admin_email = documentSnapshot["admin_email"];
        Credentials.admin_password = documentSnapshot["admin_password"];
      } else {
        print('Document does not exist on the database');
      }
    });
  }
}

class Plans {
  static double targetOverWeightAbove = 0.1;
  static double targetOEE = 20.0;
  static double scrapKgCost = 10.5;
  static int monthlyNearMissTarget = 5;
  static int mediumRisksBoundary = 5;
  static int highRisksBoundary = 12;

  static void getPlans() {
    FirebaseFirestore.instance
        .collection('Rules')
        .doc('plans')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('getPlans data: ${documentSnapshot.data()}');
        Plans.targetOverWeightAbove =
            documentSnapshot["targetOverWeightAbove"].toDouble();
        Plans.targetOEE = documentSnapshot["targetOEE"].toDouble();
        Plans.scrapKgCost = documentSnapshot["scrapKgCost"].toDouble();
        Plans.monthlyNearMissTarget =
            documentSnapshot["monthlyNearMissTarget"].toInt();
        Plans.mediumRisksBoundary =
            documentSnapshot["mediumRisksBoundary"].toInt();
        Plans.highRisksBoundary = documentSnapshot["highRisksBoundary"].toInt();
      } else {
        print('Document does not exist on the database');
      }
    });
  }
}
