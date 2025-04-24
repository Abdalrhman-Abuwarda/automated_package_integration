import 'package:automated_package_integration/core/services/component_logger.dart';
import 'package:automated_package_integration/features/maps_integration/data/maps_repository.dart';
import 'package:automated_package_integration/features/maps_integration/domain/integration_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IntegrationController extends StateNotifier<AsyncValue<IntegrationResult?>> {
  final MapsRepository _repository;
  final StateController<String?> _projectDirController;
  final TextEditingController apiKeyController;
  final ComponentLogger _logger = ComponentLogger('IntegrationController');

  IntegrationController(
      this._repository,
      this._projectDirController,
      ) : apiKeyController = TextEditingController(),
        super(const AsyncData(null));

  String? get projectDir => _projectDirController.state;

  void setProjectDir(String? dir) {
    _logger.d('Setting project directory: $dir');
    _projectDirController.state = dir;
  }

  Future<void> integrate() async {
    if (projectDir == null) {
      _logger.w('Integration attempted without selecting a project directory');
      return;
    }

    _logger.i('Starting integration for project: $projectDir');
    state = const AsyncLoading();

    try {
      final result = await _repository.integrateGoogleMaps(
        projectDir!,
        apiKeyController.text.trim(),
      );

      _logger.i('Integration completed successfully');
      state = AsyncData(result);
    } catch (e, st) {
      _logger.e('Integration failed', e, st);
      state = AsyncError(e, st);
    }
  }

  @override
  void dispose() {
    _logger.d('Disposing IntegrationController');
    apiKeyController.dispose();
    super.dispose();
  }
}