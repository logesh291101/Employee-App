class DepartmentDropDownModel {
  const DepartmentDropDownModel({
    required this.departmentId,
    required this.name,
  });

  final String departmentId;
  final String name;

  factory DepartmentDropDownModel.fromJson(Map<String, dynamic> json) {
    return DepartmentDropDownModel(
      departmentId: _asString(json['departmentid']),
      name: _asString(json['name']),
    );
  }

  static String _asString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
}
