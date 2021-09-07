import 'package:cairo_bisco_app/classes/values/Rules.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void getPlans() {
  FirebaseFirestore.instance
      .collection('Rules')
      .doc('plans')
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      print('getPlans data: ${documentSnapshot.data()}');
      Plans.targetOverWeightAbove =
          documentSnapshot["targetOverWeightAbove"].toDouble();
      Plans.targetOverWeightBelow =
          documentSnapshot["targetOverWeightBelow"].toDouble();
      Plans.targetOEE = documentSnapshot["targetOEE"].toDouble();
      Plans.targetFilmWaste = documentSnapshot["targetFilmWaste"].toDouble();
      Plans.targetScrap = documentSnapshot["targetScrap"].toDouble();
      Plans.targetScrap = documentSnapshot["targetScrap"].toDouble();
      Plans.scrapKgCost = documentSnapshot["scrapKgCost"].toDouble();
    } else {
      print('Document does not exist on the database');
    }
  });
}

void getCredentials() {
  FirebaseFirestore.instance
      .collection('Rules')
      .doc('users_credentials')
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

bool isPlt(String email, String password) {
  print("checked email :" + email);
  print("checked password :" + password);
  return email.trim().compareTo(Credentials.plt_email) == 0 &&
      password.trim().compareTo(Credentials.plt_password) == 0;
}

bool isScreen(String email, String password) {
  return email.trim().compareTo(Credentials.screen_email) == 0 &&
      password.trim().compareTo(Credentials.screen_password) == 0;
}

bool isAdmin(String email, String password) {
  return email.trim().compareTo(Credentials.admin_email) == 0 &&
      password.trim().compareTo(Credentials.admin_password) == 0;
}

bool noEmptyValues(String email, String password) {
  return email.trim().isNotEmpty && password.trim().isNotEmpty;
}

bool emptyField(String val) {
  return val.trim().isEmpty;
}
