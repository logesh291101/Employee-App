import 'package:employee_app/core/network/api_exception.dart';
import 'package:employee_app/models/eip/eip_model.dart';
import 'package:employee_app/services/eip_service.dart';

class EIPRepository {
  EIPRepository(this._eipService);

  final EIPService _eipService;

  Future<EIPModel> getEmployeeImpactPoints() async {
    try {
      return await _eipService.getEmployeeImpactPoints();
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }
}
