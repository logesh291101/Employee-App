class EmployeeProfileModel {
  EmployeeProfileModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final int status;
  final String message;
  final EmployeeProfileData data;

  factory EmployeeProfileModel.fromJson(Map<String, dynamic> json) {
    return EmployeeProfileModel(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: EmployeeProfileData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class EmployeeProfileData {
  EmployeeProfileData({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.brand,
    required this.centre,
    required this.profileImage,
    required this.joiningDate,
    required this.reportManager,
    required this.employeeNumber,
  });

  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  final String brand;
  final String centre;
  final String profileImage;
  final String joiningDate;
  final String reportManager;
  final String employeeNumber;

  factory EmployeeProfileData.fromJson(Map<String, dynamic> json) {
    return EmployeeProfileData(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      role: json['role'] ?? '',
      brand: json['brand'] ?? '',
      centre: json['centre'] ?? '',
      profileImage: json['profile_image'] ?? '',
      joiningDate: json['joining_date'] ?? '',
      reportManager: json['report_manager'] ?? '',
      employeeNumber: json['employee_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,
      'brand': brand,
      'centre': centre,
      'profile_image': profileImage,
      'joining_date': joiningDate,
      'report_manager': reportManager,
      'employee_number': employeeNumber,
    };
  }
}
