import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final packingMachinesRef = FirebaseFirestore.instance
    .collection(factory_name)
    .doc('machines')
    .collection("packing")
    .withConverter<Machine>(
      fromFirestore: (snapshot, _) => Machine.fromJson(snapshot.data()!),
      toFirestore: (machine, _) => machine.toJson(),
    );

class Machine {
  static List<String> packingMachinesList = [];

  static Map<String, String> machineDocumentNames = new Map<String, String>();
  final String name;

  Machine({
    required this.name,
  });

  Machine.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
    };
  }

  static Future<void> getPackingMachines() async {
    await packingMachinesRef.get().then((QuerySnapshot snapshot) {
      List<QueryDocumentSnapshot<Machine>> machineDocsList =
          snapshot.docs as List<QueryDocumentSnapshot<Machine>>;
      for (var machine in machineDocsList) {
        if (!packingMachinesList.contains(machine.data().name)) {
          packingMachinesList.add(machine.data().name);
          machineDocumentNames[machine.data().name.toString()] = machine.id;
        }
      }
      packingMachinesList.sort();
      print("machines fetched");
    });
  }

  static Future<void> addMachine(
    context,
    String name,
  ) async {
    if (!packingMachinesList.contains(name)) {
      await packingMachinesRef
          .add(Machine(name: name))
          .then((value) => {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Machine Added"),
                )),
                getPackingMachines(),
                // Navigator.pop(context),
              })
          .catchError((error) => {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Failed to add Machine: $error"),
                ))
              });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error :: Machine Already exists"),
      ));
    }
  }

  static Future<void> deleteMachine(
    context,
    String name,
  ) {
    return packingMachinesRef
        .doc(machineDocumentNames[name])
        .delete()
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Machine Deleted"),
              )),
              packingMachinesList.clear(),
              getPackingMachines(),
              // Navigator.pop(context),
            })
        .catchError((error) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Failed to delete Name: $error"),
              ))
            });
  }
}
