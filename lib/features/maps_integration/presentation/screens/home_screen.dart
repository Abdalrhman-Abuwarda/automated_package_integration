import 'package:automated_package_integration/core/utils/validators.dart';
import 'package:automated_package_integration/core/utils/app_strings.dart';
import 'package:automated_package_integration/features/maps_integration/providers.dart';
import 'package:automated_package_integration/features/maps_integration/presentation/widgets/directory_picker_tile.dart';
import 'package:automated_package_integration/features/maps_integration/presentation/widgets/integration_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(integrationControllerProvider.notifier);
    final integrationState = ref.watch(integrationControllerProvider);
    final projectDir = ref.watch(projectDirProvider);

    final folderOk = Validators.isValidFlutterProject(projectDir);
    final apiKeyValid =
        Validators.isValidApiKey(controller.apiKeyController.text);
    final canRun = folderOk && apiKeyValid;

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(AppStrings.appTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.homeTitle,
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    DirectoryPickerTile(
                      folderOk: folderOk,
                      projectDirProvider: projectDirProvider,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: controller.apiKeyController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.apiKeyLabel,
                        border: OutlineInputBorder(),
                      ),
                      autovalidateMode: AutovalidateMode.always,
                      validator: Validators.apiKeyValidator,
                    ),
                    const SizedBox(height: 30),
                    IntegrationStatusWidget(
                      state: integrationState,
                      canRun: canRun,
                      controller: controller,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
