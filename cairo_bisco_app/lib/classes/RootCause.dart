import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final causesRef = FirebaseFirestore.instance
    .collection(factory_name)
    .doc('down_time')
    .collection("root_causes")
    .withConverter<RootCause>(
      fromFirestore: (snapshot, _) => RootCause.fromJson(snapshot.data()!),
      toFirestore: (rootCause, _) => rootCause.toJson(),
    );

class RootCause {
  final String type;
  final String cause;

  RootCause({
    required this.type,
    required this.cause,
  });

  RootCause.fromJson(Map<String, Object?> json)
      : this(
          type: json['type']! as String,
          cause: json['cause']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'type': type,
      'cause': cause,
    };
  }

  static Map<String, List<String>> causesMap =
      new Map<String, List<String>>(); // maps every type to a group of causes
  static Map<String, String> reversedCausesMap =
      new Map<String, String>(); // maps every cause belong to which type
  static List<String> allCauses = [];
  static Map<String, String> causeDocumentNames = new Map<String, String>();

  static Future<void> addCause(
    context,
    String type,
    String cause,
  ) async {
    if (!allCauses.contains(cause)) {
      await causesRef
          .add(RootCause(type: type, cause: cause))
          .then((value) => {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Cause Added"),
                )),
                if (causesMap[type] == null) causesMap[type] = [],
                causesMap[type]!.add(cause),
                causeDocumentNames[cause] = value.id,
                reversedCausesMap[cause] = type,
                allCauses.add(cause),
                // Navigator.pop(context),
              })
          .catchError((error) => {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Failed to add Cause: $error"),
                ))
              });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error :: Cause Already exists"),
      ));
    }
  }

  static Future<void> deleteCause(
    context,
    String type,
    String cause,
  ) {
    return causesRef
        .doc(causeDocumentNames[cause])
        .delete()
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Cause Deleted"),
              )),
              allCauses.remove(cause),
              causesMap[type]!.remove(cause),
              reversedCausesMap.remove(cause),
              causeDocumentNames.remove(cause),
              // Navigator.pop(context),
            })
        .catchError((error) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Failed to delete Cause: $error"),
              ))
            });
  }

  static Future<void> getCauses() async {
    await causesRef.get().then((QuerySnapshot snapshot) {
      List<QueryDocumentSnapshot<RootCause>> causeDocsList =
          snapshot.docs as List<QueryDocumentSnapshot<RootCause>>;
      for (var v_cause in causeDocsList) {
        if (!allCauses.contains(v_cause.data().cause)) {
          if (causesMap[v_cause.data().type] == null)
            causesMap[v_cause.data().type] = [];
          causesMap[v_cause.data().type]!.add(v_cause.data().cause);
          causeDocumentNames[v_cause.data().cause] = v_cause.id;
          reversedCausesMap[v_cause.data().cause] = v_cause.data().type;
          allCauses.add(v_cause.data().cause);
        }
      }
      allCauses.sort();
      print("causes fetched");
    });
  }
}
