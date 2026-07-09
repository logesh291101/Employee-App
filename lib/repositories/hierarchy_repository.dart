import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/hierarchy/employee_hierarchy_model.dart';
import 'package:employee_app/services/hierarchy_service.dart';

class HierarchyRepository {
  HierarchyRepository(this._hierarchyService);

  final HierarchyService _hierarchyService;

  Future<EmployeeHierarchyModel> getTeamHierarchy() async {
    try {
      return await _hierarchyService.getTeamHierarchy();
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }
}
