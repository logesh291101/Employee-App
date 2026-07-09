class LoginEmployeeData {
  const LoginEmployeeData({
    required this.name,
    required this.email,
    required this.phonenumber,
    required this.role,
    required this.brand,
    required this.centre,
    required this.reportManager,
    required this.employeeNumber,
    required this.staffid,
  });

  final String name;
  final String email;
  final String phonenumber;
  final String role;
  final String brand;
  final String centre;
  final String reportManager;
  final String employeeNumber;
  final String staffid;

  factory LoginEmployeeData.fromJson(Map<String, dynamic> json) {
    return LoginEmployeeData(
      name: _asString(json['name']),
      email: _asString(json['email']),
      phonenumber: _asString(json['phonenumber']),
      role: _asString(json['role']),
      brand: _asString(json['brand']),
      centre: _asString(json['centre']),
      reportManager: _asString(json['report_manager']),
      employeeNumber: _asString(json['employee_number']),
      staffid: _asString(json['staffid']),
    );
  }

  static String _asString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
}

class LoginResponse {
  const LoginResponse({
    required this.status,
    required this.message,
    this.data,
  });

  final int status;
  final String message;
  final LoginEmployeeData? data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    return LoginResponse(
      status: json['status'] is int
          ? json['status'] as int
          : int.tryParse('${json['status']}') ?? 0,
      message: json['message'] as String? ?? '',
      data: dataJson is Map
          ? LoginEmployeeData.fromJson(Map<String, dynamic>.from(dataJson))
          : null,
    );
  }
}
