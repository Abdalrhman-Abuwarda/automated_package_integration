// lib/main.dart

import 'package:automated_package_integration/core/services/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:automated_package_integration/features/maps_integration/presentation/screens/home_screen.dart';

void main() {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    log.i('Application starting');

    runApp(
      const ProviderScope(
        child: GoogleMapsIntegratorApp(),
      ),
    );
  } catch (e, stackTrace) {
    log.e('Error during app initialization', e, stackTrace);
    rethrow;
  }
}

class GoogleMapsIntegratorApp extends StatelessWidget {
  const GoogleMapsIntegratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    log.d('Building app widget');
    return MaterialApp(
      title: 'Google Maps Integrator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
