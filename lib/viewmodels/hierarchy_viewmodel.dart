import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/hierarchy/employee_hierarchy_model.dart';
import 'package:employee_app/repositories/hierarchy_repository.dart';
import 'package:get/get.dart';

class HierarchyNode {
  const HierarchyNode({
    required this.id,
    required this.name,
    this.roleId,
    this.profilePic,
    this.email,
    this.children = const [],
  });

  final String id;
  final String name;
  final String? roleId;
  final String? profilePic;
  final String? email;
  final List<HierarchyNode> children;

  bool get hasChildren => children.isNotEmpty;
}

class HierarchyViewModel extends GetxController {
  HierarchyViewModel(this._hierarchyRepository);

  final HierarchyRepository _hierarchyRepository;

  final RxList<HierarchyNode> rootNodes = <HierarchyNode>[].obs;
  final RxSet<String> expandedNodeIds = <String>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxnString emptyMessage = RxnString();
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchHierarchy();
  }

  Future<void> fetchHierarchy({bool isRefresh = false}) async {
    if (isRefresh) {
      isRefreshing.value = true;
    } else {
      isLoading.value = true;
    }
    emptyMessage.value = null;
    errorMessage.value = null;
    rootNodes.clear();
    expandedNodeIds.clear();

    try {
      final response = await _hierarchyRepository.getTeamHierarchy();
      _applyResponse(response);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (error) {
      errorMessage.value = _resolveErrorMessage(error);
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  void _applyResponse(EmployeeHierarchyModel response) {
    if (response.status && response.data.isNotEmpty) {
      rootNodes.assignAll(
        response.data.map(_mapEmployeeData).toList(),
      );
      return;
    }

    emptyMessage.value = response.message;
  }

  HierarchyNode _mapEmployeeData(EmployeeHierarchyData data) {
    return HierarchyNode(
      id: data.id?.toString() ?? data.name,
      name: data.name,
      roleId: data.roleId,
      profilePic: data.profilePic,
      email: data.email,
      children: data.teamMembers.map(_mapTeamMember).toList(),
    );
  }

  HierarchyNode _mapTeamMember(TeamMember member) {
    return HierarchyNode(
      id: member.id.isNotEmpty ? member.id : member.name,
      name: member.name,
      roleId: member.roleId,
      profilePic: member.profilePic,
      email: member.email,
      children: member.teamMembers.map(_mapTeamMember).toList(),
    );
  }

  String _resolveErrorMessage(Object error) {
    if (error is ApiException && error.message.trim().isNotEmpty) {
      return error.message;
    }
    if (error is Exception) {
      final message = error.toString();
      if (message.trim().isNotEmpty) return message;
    }
    return error.toString();
  }

  Future<void> refreshHierarchy() async {
    await fetchHierarchy(isRefresh: true);
  }

  void toggleNode(String nodeId) {
    if (expandedNodeIds.contains(nodeId)) {
      expandedNodeIds.remove(nodeId);
    } else {
      expandedNodeIds.add(nodeId);
    }
  }

  bool isExpanded(String nodeId) => expandedNodeIds.contains(nodeId);
}
