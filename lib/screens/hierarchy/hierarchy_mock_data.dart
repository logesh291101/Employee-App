class HierarchyMockData {
  HierarchyMockData._();

  static final Map<String, dynamic> owner = {
    'id': 'EMP-0001',
    'name': 'John Smith',
    'role': 'Owner',
    'email': 'owner@company.com',
    'directReports': 10,
  };

  static final List<Map<String, dynamic>> managers = List.generate(10, (index) {
    final number = index + 1;
    final teamLeadCount = number % 3 == 0 ? 3 : (number % 2 == 0 ? 2 : 1);
    return {
      'id': 'MGR-${number.toString().padLeft(2, '0')}',
      'name': _managerNames[index],
      'role': 'Manager',
      'email': 'manager$number@company.com',
      'directReports': teamLeadCount,
      'managerIndex': index,
    };
  });

  static List<Map<String, dynamic>> teamLeadsForManager(int managerIndex) {
    final manager = managers[managerIndex];
    final count = manager['directReports'] as int;
    return List.generate(count, (index) {
      final number = index + 1;
      final employeeCount = 4 + ((managerIndex + index) % 5);
      return {
        'id': 'TL-${(managerIndex + 1).toString().padLeft(2, '0')}-$number',
        'name': _teamLeadNames[(managerIndex + index) % _teamLeadNames.length],
        'role': 'Team Lead',
        'email': 'tl${managerIndex + 1}_$number@company.com',
        'directReports': employeeCount,
        'managerIndex': managerIndex,
        'teamLeadIndex': index,
      };
    });
  }

  static List<Map<String, dynamic>> employeesForTeamLead({
    required int managerIndex,
    required int teamLeadIndex,
  }) {
    final teamLead = teamLeadsForManager(managerIndex)[teamLeadIndex];
    final count = teamLead['directReports'] as int;
    return List.generate(count, (index) {
      final number = index + 1;
      final roleIndex = (managerIndex + teamLeadIndex + index) % _employeeRoles.length;
      return {
        'id': 'EMP${(managerIndex + 1).toString().padLeft(2, '0')}${(teamLeadIndex + 1).toString().padLeft(2, '0')}${number.toString().padLeft(2, '0')}',
        'name': _employeeNames[(managerIndex * 3 + teamLeadIndex + index) %
            _employeeNames.length],
        'role': _employeeRoles[roleIndex],
        'email':
            'emp${managerIndex + 1}_${teamLeadIndex + 1}_$number@company.com',
      };
    });
  }

  static const _managerNames = [
    'Sarah Johnson',
    'Michael Chen',
    'Emily Davis',
    'Robert Wilson',
    'Lisa Anderson',
    'James Martinez',
    'Jennifer Taylor',
    'David Brown',
    'Amanda Garcia',
    'Christopher Lee',
  ];

  static const _teamLeadNames = [
    'David Wilson',
    'Priya Sharma',
    'Marcus Johnson',
    'Elena Rodriguez',
    'Kevin Patel',
    'Sophia Nguyen',
    'Daniel Kim',
    'Rachel Green',
  ];

  static const _employeeNames = [
    'Michael Brown',
    'Logesh K',
    'Anita Desai',
    'Suresh Menon',
    'Meera Nair',
    'Arjun Reddy',
    'Neha Kapoor',
    'Rahul Verma',
    'Sneha Iyer',
    'Vikram Singh',
    'Kavya Nambiar',
    'Aditya Rao',
    'Pooja Menon',
    'Sanjay Pillai',
    'Divya Krishnan',
  ];

  static const _employeeRoles = [
    'Software Engineer',
    'QA Engineer',
    'UI/UX Designer',
    'Business Analyst',
    'DevOps Engineer',
  ];
}
