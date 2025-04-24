
import 'package:automated_package_integration/features/maps_integration/data/maps_repository.dart';
import 'package:automated_package_integration/features/maps_integration/domain/integration_result.dart';
import 'package:automated_package_integration/features/maps_integration/presentation/controllers/integration_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository provider
final mapsRepositoryProvider = Provider<MapsRepository>((ref) {
  return MapsRepository();
});

// Selected project directory state
final projectDirProvider = StateProvider<String?>((ref) => null);

// Integration controller with integration state
final integrationControllerProvider = StateNotifierProvider<IntegrationController, AsyncValue<IntegrationResult?>>((ref) {
  final repository = ref.watch(mapsRepositoryProvider);
  final projectDirController = ref.read(projectDirProvider.notifier);

  return IntegrationController(repository, projectDirController);
});