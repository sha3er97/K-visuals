import 'package:cairo_bisco_app/components/utility_funcs/calculations_utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final biscuitsSkuRef =
    FirebaseFirestore.instance.collection('biscuits_sku').withConverter<SKU>(
          fromFirestore: (snapshot, _) => SKU.fromJson(snapshot.data()!),
          toFirestore: (sku, _) => sku.toJson(),
        );
final waferSkuRef =
    FirebaseFirestore.instance.collection('wafer_sku').withConverter<SKU>(
          fromFirestore: (snapshot, _) => SKU.fromJson(snapshot.data()!),
          toFirestore: (sku, _) => sku.toJson(),
        );
final maamoulSkuRef =
    FirebaseFirestore.instance.collection('maamoul_sku').withConverter<SKU>(
          fromFirestore: (snapshot, _) => SKU.fromJson(snapshot.data()!),
          toFirestore: (sku, _) => sku.toJson(),
        );
final RefSkuArr = [biscuitsSkuRef, waferSkuRef, maamoulSkuRef];

class SKU {
  final String name;
  final double cartonWeight, theoreticalShiftProd, targetScrap, targetFilmWaste;

  SKU(
      {required this.name,
      required this.cartonWeight,
      required this.theoreticalShiftProd,
      required this.targetScrap,
      required this.targetFilmWaste});

  SKU.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          cartonWeight: parseJsonToDouble(json['cartonWeight']!),
          theoreticalShiftProd:
              parseJsonToDouble(json['theoreticalShiftProd']!),
          targetScrap: parseJsonToDouble(json['targetScrap']!),
          targetFilmWaste: parseJsonToDouble(json['targetFilmWaste']!),
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'cartonWeight': cartonWeight,
      'theoreticalShiftProd': theoreticalShiftProd,
      'targetScrap': targetScrap,
      'targetFilmWaste': targetFilmWaste,
    };
  }

  static void addSKU(
      refNum,
      String name,
      double cartonWeight,
      double theoreticalShiftProd,
      double targetScrap,
      double targetFilmWaste) async {
    await RefSkuArr[refNum].add(
      SKU(
          name: name,
          cartonWeight: cartonWeight,
          theoreticalShiftProd: theoreticalShiftProd,
          targetScrap: targetScrap,
          targetFilmWaste: targetFilmWaste),
    );
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

  static void getAllSku() {
    getSKU(0, biscuitSKU);
    getSKU(1, waferSKU);
    getSKU(2, maamoulSKU);
  }

  static void getSKU(refNum, skuNamesList) async {
    List<QueryDocumentSnapshot<SKU>> skuList =
        await RefSkuArr[refNum].get().then((snapshot) => snapshot.docs);

    for (var sku in skuList) {
      if (!skuNamesList.contains(sku.data().name.toString())) {
        skuNamesList.add(sku.data().name.toString());

        skuDetails[sku.data().name.toString()] = sku.data();
      }
    }
  }
}
