import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:automated_package_integration/features/maps_integration/domain/integration_result.dart';
import 'package:automated_package_integration/features/maps_integration/presentation/controllers/integration_controller.dart';

import 'integration_button.dart';

class IntegrationStatusWidget extends StatelessWidget {
  final AsyncValue<IntegrationResult?> state;
  final bool canRun;
  final IntegrationController controller;

  const IntegrationStatusWidget({
    super.key,
    required this.state,
    required this.canRun,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      AsyncLoading() => const LinearProgressIndicator(),
      AsyncError(:final error) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                '$error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
            IntegrationButton(canRun: canRun, controller: controller),
          ],
        ),
      AsyncData(:final value) => Column(
          children: [
            if (value != null && value.hasChanges)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  '${value.successMessage} ',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            IntegrationButton(canRun: canRun, controller: controller),
          ],
        ),
      _ => IntegrationButton(canRun: canRun, controller: controller),
    };
  }
}
