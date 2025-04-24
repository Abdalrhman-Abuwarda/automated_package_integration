import 'package:automated_package_integration/features/maps_integration/domain/integration_result.dart';
import 'package:automated_package_integration/features/maps_integration/domain/integration_service.dart';

class MapsRepository {
  final IntegrationService _integrationService;

  MapsRepository({IntegrationService? integrationService})
      : _integrationService = integrationService ?? IntegrationService();

  Future<IntegrationResult> integrateGoogleMaps(
      String projectDir, String apiKey) async {
    return await _integrationService.integrate(projectDir, apiKey);
  }
}
