import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/core/utils/app_snackbar.dart';
import 'package:employee_app/models/support/department_dropdown_model.dart';
import 'package:employee_app/models/support/staff_dropdown_model.dart';
import 'package:employee_app/repositories/support_form_repository.dart';
import 'package:employee_app/utils/shared_pref_helper.dart';
import 'package:employee_app/viewmodels/support_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateSupportRequestViewModel extends GetxController {
  CreateSupportRequestViewModel(this._supportFormRepository);

  final SupportFormRepository _supportFormRepository;

  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxList<DepartmentDropDownModel> departments =
      <DepartmentDropDownModel>[].obs;
  final RxList<StaffDropDownModel> staffs = <StaffDropDownModel>[].obs;

  final Rxn<DepartmentDropDownModel> selectedDepartment = Rxn();
  final Rxn<StaffDropDownModel> selectedStaff = Rxn();
  final RxnString selectedPriority = RxnString();

  final RxBool isLoadingDepartments = false.obs;
  final RxBool isLoadingStaff = false.obs;
  final RxBool isSubmitting = false.obs;

  final RxnString categoryError = RxnString();
  final RxnString staffError = RxnString();
  final RxnString subjectError = RxnString();
  final RxnString descriptionError = RxnString();
  final RxnString priorityError = RxnString();

  final RxnString attachmentName = RxnString();
  final RxnString attachmentType = RxnString();

  static const priorities = ['Low', 'Medium', 'High', 'Critical'];

  bool get isStaffDropdownEnabled =>
      selectedDepartment.value != null && !isLoadingStaff.value;

  @override
  void onInit() {
    super.onInit();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    isLoadingDepartments.value = true;

    try {
      final result = await _supportFormRepository.getDepartments();
      departments.assignAll(result);
    } on ApiException catch (error) {
      AppSnackbar.show(error.message, isError: true);
    } catch (_) {
      AppSnackbar.show(
        'Something went wrong. Please try again.',
        isError: true,
      );
    } finally {
      isLoadingDepartments.value = false;
    }
  }

  Future<void> onDepartmentChanged(DepartmentDropDownModel? department) async {
    selectedDepartment.value = department;
    selectedStaff.value = null;
    staffs.clear();
    categoryError.value = null;
    staffError.value = null;

    if (department == null) return;

    final departmentId = int.tryParse(department.departmentId);
    if (departmentId == null) {
      AppSnackbar.show('Invalid department selected.', isError: true);
      return;
    }

    isLoadingStaff.value = true;

    try {
      final result = await _supportFormRepository.getStaffs(departmentId);
      staffs.assignAll(result);
      if (result.isEmpty) {
        AppSnackbar.show('No staff found for this category.', isError: true);
      }
    } on ApiException catch (error) {
      AppSnackbar.show(error.message, isError: true);
    } catch (_) {
      AppSnackbar.show(
        'Something went wrong. Please try again.',
        isError: true,
      );
    } finally {
      isLoadingStaff.value = false;
    }
  }

  void onStaffChanged(StaffDropDownModel? staff) {
    selectedStaff.value = staff;
    staffError.value = null;
  }

  void onPriorityChanged(String? priority) {
    selectedPriority.value = priority;
    priorityError.value = null;
  }

  void setAttachment(String name, String type) {
    attachmentName.value = name;
    attachmentType.value = type;
  }

  void removeAttachment() {
    attachmentName.value = null;
    attachmentType.value = null;
  }

  void clearForm() {
    selectedDepartment.value = null;
    selectedStaff.value = null;
    staffs.clear();
    subjectController.clear();
    descriptionController.clear();
    selectedPriority.value = null;
    attachmentName.value = null;
    attachmentType.value = null;
    categoryError.value = null;
    staffError.value = null;
    subjectError.value = null;
    descriptionError.value = null;
    priorityError.value = null;
  }

  bool _validate() {
    categoryError.value =
        selectedDepartment.value == null ? 'Please select a category' : null;
    staffError.value =
        selectedStaff.value == null ? 'Please select a staff member' : null;
    subjectError.value = subjectController.text.trim().isEmpty
        ? 'Subject is required'
        : null;
    descriptionError.value = descriptionController.text.trim().isEmpty
        ? 'Description is required'
        : null;
    priorityError.value =
        selectedPriority.value == null ? 'Please select a priority' : null;

    return categoryError.value == null &&
        staffError.value == null &&
        subjectError.value == null &&
        descriptionError.value == null &&
        priorityError.value == null;
  }

  Future<void> submit() async {
    if (!_validate() || isSubmitting.value) return;

    final staffId = await SharedPrefHelper.getStaffId();
    final requestUserId = int.tryParse(staffId);
    if (requestUserId == null || requestUserId <= 0) {
      AppSnackbar.show(
        'Unable to identify your account. Please log in again.',
        isError: true,
      );
      return;
    }

    final contactPersonId =
        int.tryParse(selectedStaff.value!.staffId);
    final category =
        int.tryParse(selectedDepartment.value!.departmentId);

    if (contactPersonId == null || category == null) {
      AppSnackbar.show('Invalid selection. Please try again.', isError: true);
      return;
    }

    isSubmitting.value = true;

    try {
      final response = await _supportFormRepository.createSupportRequest(
        requestUserId: requestUserId,
        contactPersonId: contactPersonId,
        category: category,
        subject: subjectController.text.trim(),
        description: descriptionController.text.trim(),
        priority: selectedPriority.value!,
        attachment: attachmentName.value,
      );

      AppSnackbar.show(
        response.message.isNotEmpty
            ? response.message
            : 'Support request created successfully',
      );
      clearForm();
      _refreshMyRequestsIfAvailable();
    } on ApiException catch (error) {
      AppSnackbar.show(error.message, isError: true);
      clearForm();
    } catch (_) {
      AppSnackbar.show(
        'Something went wrong. Please try again.',
        isError: true,
      );
      clearForm();
    } finally {
      isSubmitting.value = false;
    }
  }

  void clearSubjectError(String _) => subjectError.value = null;

  void clearDescriptionError(String _) => descriptionError.value = null;

  void _refreshMyRequestsIfAvailable() {
    if (Get.isRegistered<SupportViewModel>()) {
      Get.find<SupportViewModel>().fetchMyRequests(isRefresh: true);
    }
  }

  @override
  void onClose() {
    subjectController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
