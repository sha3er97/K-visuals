import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Plans {
  static double targetOverWeightAbove = 0.1;
  static double targetOEE = 20.0;
  static double scrapKgCost = 10.5;
  static int monthlyNearMissTarget = 5;
  static int mediumRisksBoundary = 5;
  static int highRisksBoundary = 12;

  static void getPlans() {
    FirebaseFirestore.instance
        .collection(factory_name)
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
