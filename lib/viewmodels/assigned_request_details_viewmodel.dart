import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/core/utils/app_snackbar.dart';
import 'package:employee_app/models/support/assigned_request_model.dart';
import 'package:employee_app/repositories/support_form_repository.dart';
import 'package:get/get.dart';

class AssignedRequestDetailsViewModel extends GetxController {
  AssignedRequestDetailsViewModel(this._supportFormRepository, this.request);

  final SupportFormRepository _supportFormRepository;
  final AssignedRequestData request;

  static const int statusInProgress = 2;
  static const int statusResolved = 3;
  static const int statusClosed = 4;

  final RxnInt updatingStatus = RxnInt();

  bool get isUpdating => updatingStatus.value != null;

  bool isStatusLoading(int status) => updatingStatus.value == status;

  Future<void> updateStatus(int status) async {
    if (isUpdating) return;

    final supportFormId = int.tryParse(request.supportFormId);
    if (supportFormId == null) {
      AppSnackbar.show(
        'Invalid support request. Please try again.',
        isError: true,
      );
      return;
    }

    updatingStatus.value = status;

    try {
      final response = await _supportFormRepository.updateSupportStatus(
        supportFormId: supportFormId,
        status: status,
      );

      AppSnackbar.show(
        response.message.isNotEmpty
            ? response.message
            : 'Support request status updated successfully',
      );
    } on ApiException catch (error) {
      AppSnackbar.show(error.message, isError: true);
    } catch (_) {
      AppSnackbar.show(
        'Something went wrong. Please try again.',
        isError: true,
      );
    } finally {
      updatingStatus.value = null;
    }
  }
}
