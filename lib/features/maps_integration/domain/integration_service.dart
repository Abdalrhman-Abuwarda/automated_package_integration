import 'package:automated_package_integration/core/services/android_configurator.dart';
import 'package:automated_package_integration/core/services/ios_configurator.dart';
import 'package:automated_package_integration/core/services/pubspec_editor.dart';
import 'package:automated_package_integration/core/services/demo_injector.dart';
import 'package:automated_package_integration/core/services/shell_utils.dart';
import 'package:automated_package_integration/core/services/component_logger.dart';
import 'package:automated_package_integration/features/maps_integration/domain/integration_result.dart';

class IntegrationService {
  final PubspecEditor _pubspecEditor;
  final AndroidConfigurator _androidConfigurator;
  final IosConfigurator _iosConfigurator;
  final DemoInjector _demoInjector;
  final ComponentLogger _logger = ComponentLogger('IntegrationService');

  IntegrationService({
    PubspecEditor? pubspecEditor,
    AndroidConfigurator? androidConfigurator,
    IosConfigurator? iosConfigurator,
    DemoInjector? demoInjector,
  }) : _pubspecEditor = pubspecEditor ?? PubspecEditor(),
        _androidConfigurator = androidConfigurator ?? const AndroidConfigurator(),
        _iosConfigurator = iosConfigurator ?? const IosConfigurator(),
        _demoInjector = demoInjector ?? const DemoInjector();

  /// Performs the integration workflow:
  /// 1. Add google_maps_flutter package
  /// 2. Inject demo screen
  /// 3. Configure platforms with API key (if provided)
  Future<IntegrationResult> integrate(String projectDir, String apiKey) async {
    _logger.i('Starting integration for project: $projectDir');

    try {
      // Add google_maps_flutter
      _logger.d('Adding google_maps_flutter package');
      final mapsAdded = await _pubspecEditor.addGoogleMaps(projectDir);
      _logger.d('Maps package added: $mapsAdded');

      // Inject demo screen 
      _logger.d('Injecting demo screen');
      final demoAdded = await _demoInjector.inject(projectDir);
      _logger.d('Demo screen injected: $demoAdded');

      // Run flutter pub get if needed
      if (mapsAdded || demoAdded) {
        _logger.d('Running flutter pub get');
        await runFlutterPubGet(projectDir);
        _logger.d('Flutter pub get completed');
      }

      // Platform configuration
      bool platformChanged = false;
      if (apiKey.isNotEmpty) {
        _logger.d('Configuring Android platform with API key');
        final androidOk = await _androidConfigurator.configure(projectDir, apiKey);
        _logger.d('Android configuration result: $androidOk');

        _logger.d('Configuring iOS platform with API key');
        final iosOk = await _iosConfigurator.configure(projectDir, apiKey);
        _logger.d('iOS configuration result: $iosOk');

        platformChanged = androidOk || iosOk;
      } else {
        _logger.d('Skipping platform configuration (no API key provided)');
      }

      final result = IntegrationResult(
        mapsAdded: mapsAdded,
        demoAdded: demoAdded,
        platformChanged: platformChanged,
      );

      _logger.i('Integration completed successfully: ${result.successMessage}');
      return result;
    } catch (e, stackTrace) {
      _logger.e('Error during integration', e, stackTrace);
      rethrow;
    }
  }
}