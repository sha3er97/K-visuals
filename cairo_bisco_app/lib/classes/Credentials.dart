import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Credentials {
  static String plt_email = ""; //plt2021@kelloggs.com
  static String plt_password = ""; //Bisco2021
  static String screen_email = ""; //screen
  static String screen_password = ""; //screen
  static String admin_email = ""; //admin
  static String admin_password = ""; //admin

  static void getCredentials() {
    FirebaseFirestore.instance
        .collection(factory_name)
        .doc('credentials')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('getCredentials data: ${documentSnapshot.data()}');
        Credentials.plt_email = documentSnapshot["plt_email"];
        Credentials.plt_password = documentSnapshot["plt_password"];
        Credentials.screen_email = documentSnapshot["screen_email"];
        Credentials.screen_password = documentSnapshot["screen_password"];
        Credentials.admin_email = documentSnapshot["admin_email"];
        Credentials.admin_password = documentSnapshot["admin_password"];
      } else {
        print('Document does not exist on the database');
      }
    });
  }
}
