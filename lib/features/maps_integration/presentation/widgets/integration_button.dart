import 'package:flutter/material.dart';
import 'package:automated_package_integration/features/maps_integration/presentation/controllers/integration_controller.dart';

class IntegrationButton extends StatelessWidget {
  final bool canRun;
  final IntegrationController controller;

  const IntegrationButton({
    super.key,
    required this.canRun,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: canRun ? controller.integrate : null,
        child: const Text('Integrate'),
      ),
    );
  }
}
