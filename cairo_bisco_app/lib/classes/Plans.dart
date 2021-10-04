import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Plans {
  static double targetOverWeightAbove = 0.1;
  static double targetOEE = 20.0;
  static double mpsaTarget = 20.0;
  static double scrapKgCost = 10.5;
  static double target_absence = 0.1;
  static int monthlyNearMissTarget = 5;
  static int mediumRisksBoundary = 5;
  static int highRisksBoundary = 12;

  static Future<void> updateRules(
    context,
    double targetOverWeightAbove,
    double targetOEE,
    double mpsaTarget,
    double scrapKgCost,
    int monthlyNearMissTarget,
    int mediumRisksBoundary,
    int highRisksBoundary,
    double target_absence,
  ) {
    return FirebaseFirestore.instance
        .collection(factory_name)
        .doc('plans')
        .update({
          'targetOverWeightAbove': targetOverWeightAbove,
          'targetOEE': targetOEE,
          'mpsaTarget': mpsaTarget,
          'scrapKgCost': scrapKgCost,
          'monthlyNearMissTarget': monthlyNearMissTarget,
          'mediumRisksBoundary': mediumRisksBoundary,
          'highRisksBoundary': highRisksBoundary,
          'target_absence': target_absence,
        })
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Targets Updated"),
              )),
              getPlans(),
              Navigator.pop(context),
            })
        .catchError((error) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Failed to update targets: $error"),
              ))
            });
  }

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
        Plans.mpsaTarget = documentSnapshot["mpsaTarget"].toDouble();
        Plans.target_absence = documentSnapshot["target_absence"].toDouble();
      } else {
        print('Document does not exist on the database');
      }
    });
  }
}
