import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/eip/eip_model.dart';
import 'package:employee_app/repositories/eip_repository.dart';
import 'package:get/get.dart';

class EIPViewModel extends GetxController {
  EIPViewModel(this._eipRepository);

  final EIPRepository _eipRepository;

  final RxList<EIPData> impactPoints = <EIPData>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxnString emptyMessage = RxnString();
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchImpactPoints();
  }

  Future<void> fetchImpactPoints({bool isRefresh = false}) async {
    if (isRefresh) {
      isRefreshing.value = true;
    } else {
      isLoading.value = true;
    }
    emptyMessage.value = null;
    errorMessage.value = null;
    impactPoints.clear();

    try {
      final response = await _eipRepository.getEmployeeImpactPoints();
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

  void _applyResponse(EIPModel response) {
    if (response.status && response.data.isNotEmpty) {
      impactPoints.assignAll(response.data);
      return;
    }

    emptyMessage.value = response.message;
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

  Future<void> refreshImpactPoints() async {
    await fetchImpactPoints(isRefresh: true);
  }
}
