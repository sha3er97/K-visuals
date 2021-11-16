import 'package:cairo_bisco_app/classes/Credentials.dart';

bool isScreen(String email, String password) {
  return email.trim().compareTo(Credentials.screen_email) == 0 &&
      password.trim().compareTo(Credentials.screen_password) == 0;
}
