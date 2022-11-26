import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/classes/values/constants.dart';

/// the variables of all targets
/// N.B.
/// values are initialized with unreasonable low values to help notice
/// if something went wrong in fetching actual values without debugging
class Plans {
  static double targetOverWeightAbove = 0.1;
  static double targetOEE = 20.0;
  static double mpsaTarget = 20.0;
  static double targetAbsence = 0.1;
  static int monthlyNearMissTarget = 5;
  static int mediumRisksBoundary = 5;
  static int highRisksBoundary = 12;
  static double universalTargetScrap = 3.0;
  static double universalTargetFilmWaste = 3.0;
  static double electConsumptionTarget = 0.5;
  static double waterConsumptionTarget = 0.5;
  static double gasConsumptionTarget = 0.5;
  static double organicWasteConsumptionTarget = 0.5;

  static Future<void> updateRules(
    context,
    double targetOverWeightAbove,
    double targetOEE,
    double mpsaTarget,
    int monthlyNearMissTarget,
    int mediumRisksBoundary,
    int highRisksBoundary,
    double targetAbsence,
    double universalTargetScrap,
    double universalTargetFilmWaste,
    double electConsumptionTarget,
    double waterConsumptionTarget,
    double gasConsumptionTarget,
    double organicWasteConsumptionTarget,
  ) {
    return FirebaseFirestore.instance
        .collection(factory_name)
        .doc('plans')
        .update({
          'targetOverWeightAbove': targetOverWeightAbove,
          'targetOEE': targetOEE,
          'mpsaTarget': mpsaTarget,
          'monthlyNearMissTarget': monthlyNearMissTarget,
          'mediumRisksBoundary': mediumRisksBoundary,
          'highRisksBoundary': highRisksBoundary,
          'targetAbsence': targetAbsence,
          'universalTargetScrap': universalTargetScrap,
          'universalTargetFilmWaste': universalTargetFilmWaste,
          'electConsumptionTarget': electConsumptionTarget,
          'waterConsumptionTarget': waterConsumptionTarget,
          'gasConsumptionTarget': gasConsumptionTarget,
          'organicWasteConsumptionTarget': organicWasteConsumptionTarget,
        })
        .then((value) => {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
      print("plans fetched");
      if (documentSnapshot.exists) {
        print('getPlans data: ${documentSnapshot.data()}');
        Plans.targetOverWeightAbove =
            documentSnapshot["targetOverWeightAbove"].toDouble();
        Plans.targetOEE = documentSnapshot["targetOEE"].toDouble();
        Plans.monthlyNearMissTarget =
            documentSnapshot["monthlyNearMissTarget"].toInt();
        Plans.mediumRisksBoundary =
            documentSnapshot["mediumRisksBoundary"].toInt();
        Plans.highRisksBoundary = documentSnapshot["highRisksBoundary"].toInt();
        Plans.mpsaTarget = documentSnapshot["mpsaTarget"].toDouble();
        Plans.targetAbsence = documentSnapshot["targetAbsence"].toDouble();
        Plans.universalTargetFilmWaste =
            documentSnapshot["universalTargetFilmWaste"].toDouble();
        Plans.universalTargetScrap =
            documentSnapshot["universalTargetScrap"].toDouble();
        Plans.waterConsumptionTarget =
            documentSnapshot["waterConsumptionTarget"].toDouble();
        Plans.electConsumptionTarget =
            documentSnapshot["electConsumptionTarget"].toDouble();
        Plans.gasConsumptionTarget =
            documentSnapshot["gasConsumptionTarget"].toDouble();
        Plans.organicWasteConsumptionTarget =
            documentSnapshot["organicWasteConsumptionTarget"].toDouble();
      } else {
        print('Document does not exist on the database');
      }
    });
  }
}
