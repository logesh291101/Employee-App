class EmployeeHierarchyModel {
  const EmployeeHierarchyModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final List<EmployeeHierarchyData> data;

  factory EmployeeHierarchyModel.fromJson(Map<String, dynamic> json) {
    return EmployeeHierarchyModel(
      status: _parseBool(json['status']),
      message: json['message']?.toString() ?? '',
      data: _parseEmployeeList(json['data']),
    );
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }

  static List<EmployeeHierarchyData> _parseEmployeeList(dynamic raw) {
    if (raw == null) return [];
    if (raw is Map) {
      return [
        EmployeeHierarchyData.fromJson(Map<String, dynamic>.from(raw)),
      ];
    }
    if (raw is! List) return [];

    final items = <EmployeeHierarchyData>[];
    for (final item in raw) {
      if (item is Map) {
        items.add(
          EmployeeHierarchyData.fromJson(Map<String, dynamic>.from(item)),
        );
      }
    }
    return items;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class EmployeeHierarchyData {
  const EmployeeHierarchyData({
    required this.id,
    required this.name,
    this.roleId,
    this.profilePic,
    this.email,
    required this.teamMembers,
  });

  final dynamic id;
  final String name;
  final String? roleId;
  final String? profilePic;
  final String? email;
  final List<TeamMember> teamMembers;

  factory EmployeeHierarchyData.fromJson(Map<String, dynamic> json) {
    return EmployeeHierarchyData(
      id: json['id'],
      name: json['name']?.toString() ?? '',
      roleId: json['role_id']?.toString(),
      profilePic: json['profile_pic']?.toString(),
      email: json['email']?.toString(),
      teamMembers: _parseTeamMembers(json['team_members']),
    );
  }

  static List<TeamMember> _parseTeamMembers(dynamic raw) {
    if (raw == null) return [];
    if (raw is! List) return [];

    final items = <TeamMember>[];
    for (final item in raw) {
      if (item is Map) {
        items.add(TeamMember.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    return items;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role_id': roleId,
      'profile_pic': profilePic,
      'email': email,
      'team_members': teamMembers.map((e) => e.toJson()).toList(),
    };
  }
}

class TeamMember {
  const TeamMember({
    required this.id,
    required this.name,
    required this.roleId,
    this.profilePic,
    this.email,
    required this.teamMembers,
  });

  final String id;
  final String name;
  final String roleId;
  final String? profilePic;
  final String? email;
  final List<TeamMember> teamMembers;

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      roleId: json['role_id']?.toString() ?? '',
      profilePic: json['profile_pic']?.toString(),
      email: json['email']?.toString(),
      teamMembers: EmployeeHierarchyData._parseTeamMembers(json['team_members']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role_id': roleId,
      'profile_pic': profilePic,
      'email': email,
      'team_members': teamMembers.map((e) => e.toJson()).toList(),
    };
  }
}
