import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Credentials {
  static String plt_email = "";
  static String plt_password = "";
  static String screen_email = ""; //screen@kelloggs.com
  static String screen_password = "";
  static String admin_email = "";
  static String admin_password = "";

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
