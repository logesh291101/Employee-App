import 'package:employee_app/models/support/assigned_request_model.dart';
import 'package:employee_app/repositories/support_form_repository.dart';
import 'package:employee_app/viewmodels/assigned_request_details_viewmodel.dart';
import 'package:get/get.dart';

class AssignedRequestDetailsBinding extends Bindings {
  AssignedRequestDetailsBinding(this.request);

  final AssignedRequestData request;

  @override
  void dependencies() {
    Get.lazyPut<AssignedRequestDetailsViewModel>(
      () => AssignedRequestDetailsViewModel(
        Get.find<SupportFormRepository>(),
        request,
      ),
    );
  }
}
