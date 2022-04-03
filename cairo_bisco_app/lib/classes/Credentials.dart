import 'package:cairo_bisco_app/classes/Admin.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Admin.dart';

final adminsRef = FirebaseFirestore.instance
    .collection(factory_name)
    .doc('credentials')
    .collection("admins")
    .withConverter<Admin>(
      fromFirestore: (snapshot, _) => Admin.fromJson(snapshot.data()!),
      toFirestore: (admin, _) => admin.toJson(),
    );
final ownersRef = FirebaseFirestore.instance
    .collection(factory_name)
    .doc('credentials')
    .collection("owners")
    .withConverter<Admin>(
      fromFirestore: (snapshot, _) => Admin.fromJson(snapshot.data()!),
      toFirestore: (Admin, _) => Admin.toJson(),
    );

class Credentials {
  /** rules **/
  static int lastVersionCode = 999; //last version uploaded on play store
  static bool isSimpleCalculation = false;

  /** back doors**/
  static String screen_email = ""; //screen
  static String screen_password = ""; //screen
  // static String admin_email = ""; //admin
  // static String admin_password = ""; //admin

  /**contain list of emails of authorized and special users*/
  static List<String> admin_emails = [];
  static List<String> owner_emails = [];

  /** mark special and authorized users**/
  static bool isUserAdmin = false;
  static bool isUserOwner = false;
  static String userEmail = "";
  static String userAuthority = "";

  static Map<String, String> adminDocumentNames = new Map<String, String>();
  static Map<String, String> ownerDocumentNames = new Map<String, String>();
  static Map<String, String> adminsAuthorities = new Map<String, String>();

  static void setCredentialsConfig(String email) {
    if (Credentials.isAdmin(email)) {
      Credentials.isUserAdmin = true;
      Credentials.userAuthority = adminsAuthorities[email]!;
    } else {
      Credentials.isUserAdmin = false;
    }
    if (Credentials.isOwner(email)) {
      Credentials.isUserOwner = true;
    } else {
      Credentials.isUserOwner = false;
    }
    // in all cases
    Credentials.userEmail = email;
  }

  static String getUserName() {
    String name = userEmail.split("@")[0];
    List<String> nameParts = name.split(".");
    String modifiedName = "";
    for (String part in nameParts) {
      modifiedName += part + " ";
    }
    return modifiedName;
  }

  static bool isAdmin(String email) {
    return admin_emails.contains(email.trim());
  }

  static bool isOwner(String email) {
    return owner_emails.contains(email.trim());
  }

  static Future<void> getAdmins() async {
    await adminsRef.get().then((QuerySnapshot snapshot) {
      List<QueryDocumentSnapshot<Admin>> adminDocsList =
          snapshot.docs as List<QueryDocumentSnapshot<Admin>>;
      for (var admin in adminDocsList) {
        if (!admin_emails.contains(admin.data().email)) {
          admin_emails.add(admin.data().email);
          adminDocumentNames[admin.data().email] = admin.id;
          adminsAuthorities[admin.data().email] = admin.data().authority;
        }
      }
      admin_emails.sort();
      print("admins fetched");
    });
  }

  static Future<void> getOwners() async {
    await ownersRef.get().then((QuerySnapshot snapshot) {
      List<QueryDocumentSnapshot<Admin>> adminDocsList =
          snapshot.docs as List<QueryDocumentSnapshot<Admin>>;
      for (var admin in adminDocsList) {
        if (!owner_emails.contains(admin.data().email)) {
          owner_emails.add(admin.data().email);
          ownerDocumentNames[admin.data().email.toString()] = admin.id;
        }
      }
      owner_emails.sort();
      print("owners fetched");
    });
  }

  static Future<void> addAdmin(
    context,
    String email,
    String authority,
  ) async {
    if (!admin_emails.contains(email)) {
      await adminsRef
          .add(Admin(email: email, authority: authority))
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error :: Email Already exists"),
      ));
    }
  }

  static Future<void> addOwner(
    context,
    String email,
  ) async {
    if (!owner_emails.contains(email)) {
      await ownersRef
          .add(Admin(email: email, authority: authorities[0]))
          .then((value) => {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Email Added"),
                )),
                getOwners(),
                // Navigator.pop(context),
              })
          .catchError((error) => {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Failed to add Email: $error"),
                ))
              });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error :: Email Already exists"),
      ));
    }
  }

  static Future<void> deleteAdmin(
    context,
    String email,
  ) {
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
  }

  static Future<void> deleteOwner(
    context,
    String email,
  ) {
    return adminsRef
        .doc(ownerDocumentNames[email])
        .delete()
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Email Deleted"),
              )),
              owner_emails.clear(),
              getOwners(),
              // Navigator.pop(context),
            })
        .catchError((error) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Failed to delete Email: $error"),
              ))
            });
  }

  static Future<void> getCredentials() async {
    await FirebaseFirestore.instance
        .collection(factory_name)
        .doc('credentials')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print("credentials fetched");
      if (documentSnapshot.exists) {
        Credentials.screen_email = documentSnapshot["screen_email"];
        Credentials.screen_password = documentSnapshot["screen_password"];
        // Credentials.admin_email = documentSnapshot["admin_email"];
        // Credentials.admin_password = documentSnapshot["admin_password"];
        Credentials.lastVersionCode =
            documentSnapshot["lastVersionCode"].toInt();
        Credentials.isSimpleCalculation =
            documentSnapshot["isSimpleCalculation"];
      } else {
        print('Document does not exist on the database');
      }
    });
  }
}
