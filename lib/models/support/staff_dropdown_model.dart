class StaffDropDownModel {
  const StaffDropDownModel({
    required this.staffId,
    required this.name,
  });

  final String staffId;
  final String name;

  factory StaffDropDownModel.fromJson(Map<String, dynamic> json) {
    return StaffDropDownModel(
      staffId: _asString(json['staffid']),
      name: _asString(json['name']),
    );
  }

  static String _asString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
}
