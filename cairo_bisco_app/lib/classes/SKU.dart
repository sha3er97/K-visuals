import 'package:cairo_bisco_app/classes/MachineDetail.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/calculations_utility.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/ui/error_success_screens/success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final biscuitsSkuRef = FirebaseFirestore.instance
    .collection(factory_name)
    .doc('sku')
    .collection('biscuits_sku')
    .withConverter<SKU>(
      fromFirestore: (snapshot, _) => SKU.fromJson(snapshot.data()!),
      toFirestore: (sku, _) => sku.toJson(),
    );
final waferSkuRef = FirebaseFirestore.instance
    .collection(factory_name)
    .doc('sku')
    .collection('wafer_sku')
    .withConverter<SKU>(
      fromFirestore: (snapshot, _) => SKU.fromJson(snapshot.data()!),
      toFirestore: (sku, _) => sku.toJson(),
    );
final maamoulSkuRef = FirebaseFirestore.instance
    .collection(factory_name)
    .doc('sku')
    .collection('maamoul_sku')
    .withConverter<SKU>(
      fromFirestore: (snapshot, _) => SKU.fromJson(snapshot.data()!),
      toFirestore: (sku, _) => sku.toJson(),
    );
final RefSkuArr = [biscuitsSkuRef, waferSkuRef, maamoulSkuRef];

class SKU {
  final String name;
  final double cartonWeight,
      targetScrap,
      targetFilmWaste,
      theoreticalShiftProd1,
      theoreticalShiftProd2,
      theoreticalShiftProd3,
      theoreticalShiftProd4,
      rm_cost, //cost for one carton of scrap
      pm_cost, // cost of film waste (pack Muv)
      pieceWeight;

  final int boxesPerCarton;

/*******************************************************************************/
  static List<String> biscuitSKU = <String>[];
  static List<String> waferSKU = <String>[];
  static List<String> maamoulSKU = <String>[];
  static Map<String, SKU> skuDetails = new Map<String, SKU>();
  static Map<String, String> skuDocumentNames = new Map<String, String>();
  static List<List<String>> allSkus = [biscuitSKU, waferSKU, maamoulSKU];
  static Map<String, List<MachineDetail>> skuMachineDetails =
      new Map<String, List<MachineDetail>>();

/************************************************************************************/
  SKU({
    required this.name,
    required this.cartonWeight,
    required this.theoreticalShiftProd1,
    required this.theoreticalShiftProd2,
    required this.theoreticalShiftProd3,
    required this.theoreticalShiftProd4,
    required this.targetScrap,
    required this.boxesPerCarton,
    required this.targetFilmWaste,
    required this.rm_cost,
    required this.pm_cost,
    required this.pieceWeight,
  });

  SKU.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          boxesPerCarton: json['boxesPerCarton']! as int,
          cartonWeight: parseJsonToDouble(json['cartonWeight']!),
          theoreticalShiftProd1:
              parseJsonToDouble(json['theoreticalShiftProd1']!),
          theoreticalShiftProd2:
              parseJsonToDouble(json['theoreticalShiftProd2']!),
          theoreticalShiftProd3:
              parseJsonToDouble(json['theoreticalShiftProd3']!),
          theoreticalShiftProd4:
              parseJsonToDouble(json['theoreticalShiftProd4']!),
          targetScrap: parseJsonToDouble(json['targetScrap']!),
          targetFilmWaste: parseJsonToDouble(json['targetFilmWaste']!),
          rm_cost: parseJsonToDouble(json['rm_cost']!),
          pm_cost: parseJsonToDouble(json['pm_cost']!),
          pieceWeight: json['pieceWeight'] == null
              ? 0
              : parseJsonToDouble(json['pieceWeight']!),
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'cartonWeight': cartonWeight,
      'theoreticalShiftProd1': theoreticalShiftProd1,
      'theoreticalShiftProd2': theoreticalShiftProd2,
      'theoreticalShiftProd3': theoreticalShiftProd3,
      'theoreticalShiftProd4': theoreticalShiftProd4,
      'targetScrap': targetScrap,
      'boxesPerCarton': boxesPerCarton,
      'targetFilmWaste': targetFilmWaste,
      'rm_cost': rm_cost,
      'pm_cost': pm_cost,
      'pieceWeight': pieceWeight,
    };
  }

  static void addSKU(
    int refNum,
    String name,
    double cartonWeight,
    double theoreticalShiftProd1,
    double theoreticalShiftProd2,
    double theoreticalShiftProd3,
    double theoreticalShiftProd4,
    double targetScrap,
    double targetFilmWaste,
    int boxesPerCarton,
    double rm_cost,
    double pm_cost,
    double pieceWeight,
  ) async {
    await RefSkuArr[refNum].add(
      SKU(
        name: name,
        cartonWeight: cartonWeight,
        theoreticalShiftProd1: theoreticalShiftProd1,
        theoreticalShiftProd2: theoreticalShiftProd2,
        theoreticalShiftProd3: theoreticalShiftProd3,
        theoreticalShiftProd4: theoreticalShiftProd4,
        targetScrap: targetScrap,
        boxesPerCarton: boxesPerCarton,
        targetFilmWaste: targetFilmWaste,
        rm_cost: rm_cost,
        pm_cost: pm_cost,
        pieceWeight: pieceWeight,
      ),
    );
  }

  static Future<void> addMachineDetail(
    context,
    int refNum,
    String skuName,
    String machineName,
    int pcsPerMin,
    int line_index,
  ) async {
    await RefSkuArr[refNum]
        .doc(skuDocumentNames[skuName])
        .collection('machines')
        .withConverter<MachineDetail>(
          fromFirestore: (snapshot, _) =>
              MachineDetail.fromJson(snapshot.data()!),
          toFirestore: (MachineDetail, _) => MachineDetail.toJson(),
        )
        .doc()
        .set(
          MachineDetail(
              name: machineName, pcsPerMin: pcsPerMin, line_index: line_index),
        )
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Machines Updated"),
              )),
              getAllSku(),
              Navigator.pop(context),
            })
        .catchError((error) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Failed to update SKU: $error"),
              ))
            });
    ;
  }

  static Future<void> editSKU(
    context,
    int refNum,
    String name,
    double cartonWeight,
    double theoreticalShiftProd1,
    double theoreticalShiftProd2,
    double theoreticalShiftProd3,
    double theoreticalShiftProd4,
    double targetScrap,
    double targetFilmWaste,
    int boxesPerCarton,
    double rm_cost,
    double pm_cost,
    double pieceWeight,
  ) {
    return RefSkuArr[refNum]
        .doc(skuDocumentNames[name])
        .update({
          // 'name': name,
          'cartonWeight': cartonWeight,
          'theoreticalShiftProd1': theoreticalShiftProd1,
          'theoreticalShiftProd2': theoreticalShiftProd2,
          'theoreticalShiftProd3': theoreticalShiftProd3,
          'theoreticalShiftProd4': theoreticalShiftProd4,
          'targetScrap': targetScrap,
          'boxesPerCarton': boxesPerCarton,
          'targetFilmWaste': targetFilmWaste,
          'rm_cost': rm_cost,
          'pm_cost': pm_cost,
          'pieceWeight': pieceWeight,
        })
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("SKU Updated"),
              )),
              getAllSku(),
              Navigator.pop(context),
            })
        .catchError((error) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Failed to update SKU: $error"),
              ))
            });
  }

  static Future<void> deleteSku(
    context,
    int refNum,
    String name,
  ) {
    return RefSkuArr[refNum]
        .doc(skuDocumentNames[name])
        .delete()
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("SKU Deleted"),
              )),
              clearSkuList(),
              getAllSku(),
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SuccessScreen())),
            })
        .catchError((error) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Failed to delete SKU: $error"),
              ))
            });
  }

  static Future<void> deleteMachineDetail(
    context,
    int refNum,
    String skuName,
    String detailId,
  ) {
    return RefSkuArr[refNum]
        .doc(skuDocumentNames[skuName])
        .collection('machines')
        .doc(detailId)
        .delete()
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Detail Deleted"),
              )),
              getAllSku(),
            })
        .catchError((error) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Failed to delete Detail: $error"),
              ))
            });
  }

  static void clearSkuList() {
    biscuitSKU.clear();
    waferSKU.clear();
    maamoulSKU.clear();
  }

  static void getAllSku() {
    getSKU(BISCUIT_AREA, biscuitSKU);
    getSKU(WAFER_AREA, waferSKU);
    getSKU(MAAMOUL_AREA, maamoulSKU);
  }

  static void getSKU(refNum, skuNamesList) async {
    List<QueryDocumentSnapshot<SKU>> skuList =
        await RefSkuArr[refNum].get().then((snapshot) => snapshot.docs);

    for (var sku in skuList) {
      if (!skuNamesList.contains(sku.data().name.toString())) {
        skuNamesList.add(sku.data().name.toString());
      }
      skuDetails[sku.data().name.toString()] = sku.data();
      skuDocumentNames[sku.data().name.toString()] = sku.id;
      //3.1.0 additions
      skuMachineDetails[sku.data().name.toString()] = [];

      List<QueryDocumentSnapshot<MachineDetail>> machineDetailList =
          await RefSkuArr[refNum]
              .doc(skuDocumentNames[sku.data().name.toString()])
              .collection('machines')
              .withConverter<MachineDetail>(
                fromFirestore: (snapshot, _) =>
                    MachineDetail.fromJson(snapshot.data()!),
                toFirestore: (MachineDetail, _) => MachineDetail.toJson(),
              )
              .get()
              .then((snapshot) => snapshot.docs);
      skuMachineDetails[sku.data().name.toString()]!.clear();
      for (var machine in machineDetailList) {
        // machine.data().id = machine.id;
        MachineDetail temp = machine.data();
        temp.setID(machine.id);
        skuMachineDetails[sku.data().name.toString()]!.add(temp);
      }
    }
  }

  static int getMachineTheoretical(mcName, skuName, line_index) {
    for (MachineDetail detail in skuMachineDetails[skuName]!) {
      if (detail.name.compareTo(mcName) == 0 &&
          detail.line_index == line_index) {
        return detail.pcsPerMin;
      }
    }
    return 0;
  }
}
