class Admin {
  final String email;

  Admin({
    required this.email,
  });

  Admin.fromJson(Map<String, Object?> json)
      : this(
          email: json['email']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'email': email,
    };
  }
}
