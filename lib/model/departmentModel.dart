class DepartmentModel {
  final int departmentId;
  final String name;

  DepartmentModel({
    required this.departmentId,
    required this.name,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      departmentId: json['department_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'department_id': departmentId,
      'name': name,
    };
  }

  DepartmentModel copyWith({
    int? departmentId,
    String? name,
  }) {
    return DepartmentModel(
      departmentId: departmentId ?? this.departmentId,
      name: name ?? this.name,
    );
  }
}
