class Owner {
  final String email;

  Owner({
    required this.email,
  });

  Owner.fromJson(Map<String, Object?> json)
      : this(
          email: json['email']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'email': email,
    };
  }
}
