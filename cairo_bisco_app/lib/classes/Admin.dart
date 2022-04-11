import 'package:cairo_bisco_app/classes/values/form_values.dart';

class Admin {
  final String email;
  final String authority;

  Admin({
    required this.email,
    required this.authority,
  });

  Admin.fromJson(Map<String, Object?> json)
      : this(
          email: json['email']! as String,
          authority: json['authority'] == null
              ? authorities[0]
              : json['authority']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'authority': authority,
    };
  }
}
