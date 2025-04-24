/// A utility class to manage all string resources in the application.
/// This centralizes text content for easier maintenance and localization.
class AppStrings {
  // App general
  static const appTitle = 'Google Maps Integrator';

  // Home screen
  static const homeTitle = 'Google Maps Integrator';
  static const selectDirectory = 'Select Flutter Project Directory';
  static const apiKeyLabel = 'Google Maps API key (optional)';
  static const integrateButton = 'Integrate';

  // Directory picker
  static const noPubspecFound = 'No pubspec.yaml file found in this directory.';
  static const notFlutterProject = 'Not a Flutter project (no flutter section in pubspec.yaml).';

  // Integration status
  static const mapsAdded = 'google_maps_flutter added';
  static const demoAdded = 'Demo screen injected';
  static const packagesFetched = 'packages fetched';
  static const platformConfigured = 'Platform configured';
  static const platformAlreadyConfigured = 'Platform already configured';
  static const integrationSuccess = '✅';

  // Form validation
  static const invalidApiKey = 'Invalid API key';

  // Error messages
  static const genericError = 'An error occurred. Please try again.';
  static const directoryAccessError = 'Could not access the selected directory.';
  static const pubspecEditError = 'Failed to modify pubspec.yaml file.';
  static const androidConfigError = 'Failed to configure Android platform.';
  static const iosConfigError = 'Failed to configure iOS platform.';
}