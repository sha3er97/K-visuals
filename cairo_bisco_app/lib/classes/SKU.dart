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
  final double cartonWeight, targetScrap, targetFilmWaste;
  final double theoreticalShiftProd1,
      theoreticalShiftProd2,
      theoreticalShiftProd3,
      theoreticalShiftProd4;
  final int boxesPerCarton;

  SKU(
      {required this.name,
      required this.cartonWeight,
      required this.theoreticalShiftProd1,
      required this.theoreticalShiftProd2,
      required this.theoreticalShiftProd3,
      required this.theoreticalShiftProd4,
      required this.targetScrap,
      required this.boxesPerCarton,
      required this.targetFilmWaste});

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
      int boxesPerCarton) async {
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
          targetFilmWaste: targetFilmWaste),
    );
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
      int boxesPerCarton) {
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
        })
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("SKU Updated"),
              )),
              getAllSku(),
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SuccessScreen())),
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

  static List<String> biscuitSKU = <String>[
    // 'COLO Soft Melt Striped Bar سوفت ميلت فانيليا',
    // 'COLO Soft Melt Cocoa Bar سوفت ميلت شوكلاتة',
    // 'Datto Flat Stack داتو فلات ستاك',
    // 'Datto King size 53gm داتو كينج سايز',
    // 'Lux DAT Small لوكس عجوة صغير',
    // 'Lux DAT Big لوكس عجوة كبير',
    // 'DATE 100 G 4PC WFP عجوة',
    // 'Asrt.Petfour Sprinkles EXP بيتي فور فارماسيل تصدير',
    // 'El Eid Bis Orange EXP بسكويت بالبرتقال تصدير',
    // 'El Eid Bis VAN EXP بسكويت العيد فانيليا تصدير',
    // 'Asrt.PETFOUR SPRINKLES بيتي فور فارماسيل',
    // 'PETIT FOUR PLAIN بيتي فور سادة 1 كيلو',
    // 'EL EID BIS VAN بسكويت العيد فانيليا',
    // 'EL EID BIS ORANGE بسكويت برتقال 1 كيلو',
  ];
  static List<String> waferSKU = <String>[
    // 'WAF VAN Small ويفر فانيليا صغير',
    // 'WAF VAN Big ويفر فانيليا كبير',
    // 'WAF Lovers Cocoa كوكو لافرز شوكلاتة',
    // 'WAF Lovers Hazl كوكو لافرز بالبندق'
  ];
  static List<String> maamoulSKU = <String>[
    // 'MAMUL معمول',
    // 'MAMUL Veg معمول صيامي',
    // 'Kahk Plain EXP كعك سادة تصدير',
    // 'Kahk Fill Agamaya EXP كعك عجمية تصدير',
    // 'Kahk Fill Malban EXP كعك بالملبن تصدير',
    // 'Kahk Fill Walnut EXP كعك عين جمل تصدير',
    // 'Plain Ghorayeba EXP غريبة سادة تصدير',
    // 'Dluxe Eid Assortment 2 kg EXP مشكل 2 كيلو تصدير',
    // 'Kahk Date EXP كعك بالعجوة تصدير',
    // 'KAHK PLAIN كعك سادة',
    // 'KAHK FILL AGAMAYA كعك عجمية',
    // 'KAHK FILL MALBAN كعك بالملبن',
    // 'KAHK FILL WALNUT كعك عين جمل',
    // 'KAHK DATE  كعك بالعجوة',
    // 'Dluxe Eid Assortment 2kg مشكل 2 كيلو',
    // 'Plain Ghorayeba غريبة سادة'
  ];
  static Map<String, SKU> skuDetails = new Map<String, SKU>();
  static Map<String, String> skuDocumentNames = new Map<String, String>();

  static void getAllSku() {
    biscuitSKU.clear();
    getSKU(BISCUIT_AREA, biscuitSKU);
    waferSKU.clear();
    getSKU(WAFER_AREA, waferSKU);
    maamoulSKU.clear();
    getSKU(MAAMOUL_AREA, maamoulSKU);
    print("skus fetched");
  }

  static void getSKU(refNum, skuNamesList) async {
    List<QueryDocumentSnapshot<SKU>> skuList =
        await RefSkuArr[refNum].get().then((snapshot) => snapshot.docs);

    for (var sku in skuList) {
      if (!skuNamesList.contains(sku.data().name.toString())) {
        skuNamesList.add(sku.data().name.toString());

        skuDetails[sku.data().name.toString()] = sku.data();
        skuDocumentNames[sku.data().name.toString()] = sku.id;
      }
    }
  }
}
