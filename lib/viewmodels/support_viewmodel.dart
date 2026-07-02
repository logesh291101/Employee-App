import 'package:employee_app/bindings/create_support_request_binding.dart';
import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/support/assigned_request_model.dart';
import 'package:employee_app/models/support/raised_request_model.dart';
import 'package:employee_app/repositories/support_form_repository.dart';
import 'package:employee_app/screens/support/create_support_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SupportViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  SupportViewModel(this._supportFormRepository);

  final SupportFormRepository _supportFormRepository;

  late final TabController tabController;

  final RxList<RaisedRequestData> myRequests = <RaisedRequestData>[].obs;
  final RxBool isLoadingMyRequests = false.obs;
  final RxBool isRefreshingMyRequests = false.obs;
  final RxnString myRequestsEmptyMessage = RxnString();
  final RxnString myRequestsError = RxnString();

  final RxList<AssignedRequestData> assignedRequests =
      <AssignedRequestData>[].obs;
  final RxBool isLoadingAssignedRequests = false.obs;
  final RxBool isRefreshingAssignedRequests = false.obs;
  final RxnString assignedRequestsEmptyMessage = RxnString();
  final RxnString assignedRequestsError = RxnString();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchMyRequests();
    fetchAssignedRequests();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> fetchMyRequests({bool isRefresh = false}) async {
    if (isRefresh) {
      isRefreshingMyRequests.value = true;
    } else {
      isLoadingMyRequests.value = true;
    }
    myRequestsEmptyMessage.value = null;
    myRequestsError.value = null;
    myRequests.clear();

    try {
      final response = await _supportFormRepository.getMyRequests();
      _applyMyRequestsResponse(response);
    } on ApiException catch (error) {
      myRequestsError.value = error.message;
    } catch (error) {
      myRequestsError.value = _resolveErrorMessage(error);
    } finally {
      isLoadingMyRequests.value = false;
      isRefreshingMyRequests.value = false;
    }
  }

  void _applyMyRequestsResponse(RaisedRequestModel response) {
    if (response.status == 1 && response.data.isNotEmpty) {
      myRequests.assignAll(response.data);
      return;
    }

    myRequestsEmptyMessage.value = response.message;
  }

  Future<void> refreshMyRequests() async {
    await fetchMyRequests(isRefresh: true);
  }

  Future<void> fetchAssignedRequests({bool isRefresh = false}) async {
    if (isRefresh) {
      isRefreshingAssignedRequests.value = true;
    } else {
      isLoadingAssignedRequests.value = true;
    }
    assignedRequestsEmptyMessage.value = null;
    assignedRequestsError.value = null;
    assignedRequests.clear();

    try {
      final response = await _supportFormRepository.getAssignedRequests();
      _applyAssignedRequestsResponse(response);
    } on ApiException catch (error) {
      assignedRequestsError.value = error.message;
    } catch (error) {
      assignedRequestsError.value = _resolveErrorMessage(error);
    } finally {
      isLoadingAssignedRequests.value = false;
      isRefreshingAssignedRequests.value = false;
    }
  }

  void _applyAssignedRequestsResponse(AssignedRequestModel response) {
    if (response.status == 1 && response.data.isNotEmpty) {
      assignedRequests.assignAll(response.data);
      return;
    }

    assignedRequestsEmptyMessage.value = response.message;
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

  Future<void> refreshAssignedRequests() async {
    await fetchAssignedRequests(isRefresh: true);
  }

  Future<void> openCreateRequest() async {
    HapticFeedback.lightImpact();
    await Get.to(
      () => const CreateSupportRequestScreen(),
      binding: CreateSupportRequestBinding(),
    );
  }
}
