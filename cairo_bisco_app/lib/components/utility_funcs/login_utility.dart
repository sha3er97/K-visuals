import 'package:cairo_bisco_app/classes/Credentials.dart';

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
