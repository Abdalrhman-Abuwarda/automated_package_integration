import 'package:automated_package_integration/core/utils/app_strings.dart';

class IntegrationResult {
  final bool mapsAdded;
  final bool demoAdded;
  final bool platformChanged;

  const IntegrationResult({
    this.mapsAdded = false,
    this.demoAdded = false,
    this.platformChanged = false,
  });

  String get successMessage {
    final parts = <String>[];
    if (mapsAdded) parts.add(AppStrings.mapsAdded);
    if (demoAdded) parts.add(AppStrings.demoAdded);
    if (mapsAdded || demoAdded) parts.add(AppStrings.packagesFetched);
    if (platformChanged) {
      parts.add(AppStrings.platformConfigured);
    } else if (parts.isNotEmpty) {
      parts.add(AppStrings.platformAlreadyConfigured);
    }
    return '${parts.join(' • ')} ${AppStrings.integrationSuccess}';
  }

  bool get hasChanges => mapsAdded || demoAdded || platformChanged;
}
