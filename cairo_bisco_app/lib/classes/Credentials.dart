import 'package:cairo_bisco_app/classes/Admin.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final adminsRef = FirebaseFirestore.instance
    .collection(factory_name)
    .doc('credentials')
    .collection("admins")
    .withConverter<Admin>(
      fromFirestore: (snapshot, _) => Admin.fromJson(snapshot.data()!),
      toFirestore: (admin, _) => admin.toJson(),
    );

class Credentials {
  /** rules **/
  static int lastVersionCode = 0; //last version uploaded on play store

  /** back doors**/
  static String screen_email = ""; //screen
  static String screen_password = ""; //screen
  static String admin_email = ""; //admin
  static String admin_password = ""; //admin

  /**contain list of emails to sign in as plt*/
  static List<String> admin_emails = [];
  static bool isUserAdmin = false;

  static Map<String, String> adminDocumentNames = new Map<String, String>();

  static bool isAdmin(String email) {
    return admin_emails.contains(email.trim());
  }

  static Future<void> getAdmins() {
    return adminsRef.get().then((QuerySnapshot snapshot) {
      List<QueryDocumentSnapshot<Admin>> adminDocsList =
      snapshot.docs as List<QueryDocumentSnapshot<Admin>>;
      for (var admin in adminDocsList) {
        if (!admin_emails.contains(admin.data().email)) {
          admin_emails.add(admin.data().email);
          adminDocumentNames[admin.data().email.toString()] = admin.id;
        }
      }
      print("admins fetched");
    });
  }

  static Future<void> addAdmin(context,
      String email,) {
    return adminsRef
        .add(Admin(email: email))
        .then((value) => {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Email Added"),
      )),
      getAdmins(),
      // Navigator.pop(context),
    })
        .catchError((error) => {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to add Email: $error"),
      ))
    });
    ;
  }

  static Future<void> deleteAdmin(context,
      String email,) {
    return adminsRef
        .doc(adminDocumentNames[email])
        .delete()
        .then((value) => {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Email Deleted"),
      )),
      admin_emails.clear(),
      getAdmins(),
      // Navigator.pop(context),
    })
        .catchError((error) => {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to delete Email: $error"),
      ))
    });
    ;
  }

  static Future<void> getCredentials() {
    return FirebaseFirestore.instance
        .collection(factory_name)
        .doc('credentials')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print("credentials fetched");
      if (documentSnapshot.exists) {
        Credentials.screen_email = documentSnapshot["screen_email"];
        Credentials.screen_password = documentSnapshot["screen_password"];
        Credentials.admin_email = documentSnapshot["admin_email"];
        Credentials.admin_password = documentSnapshot["admin_password"];
        Credentials.lastVersionCode =
            documentSnapshot["lastVersionCode"].toInt();
      } else {
        print('Document does not exist on the database');
      }
    });
  }
}
