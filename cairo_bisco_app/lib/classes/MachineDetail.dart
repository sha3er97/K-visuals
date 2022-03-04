class MachineDetail {
  final String name;
  final int pcsPerMin, line_index;
  late String id;

  MachineDetail({
    required this.name,
    required this.pcsPerMin,
    required this.line_index,
  });

  MachineDetail.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          pcsPerMin: json['pcsPerMin']! as int,
          line_index: json['line_index']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'pcsPerMin': pcsPerMin,
      'line_index': line_index,
    };
  }
}
