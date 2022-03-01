class MachineDetail {
  final String name;
  final int num;

  MachineDetail({
    required this.name,
    required this.num,
  });

  MachineDetail.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          num: json['num']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
    };
  }
}
