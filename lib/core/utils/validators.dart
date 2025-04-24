// lib/core/utils/validators.dart

import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

class Validators {
  static bool isValidApiKey(String? value) {
    final v = value ?? '';
    return v.isEmpty || RegExp(r'^[A-Za-z0-9_\\-]{30,}$').hasMatch(v);
  }

  static bool isValidFlutterProject(String? path) {
    if (path == null) return false;

    final file = File(p.join(path, 'pubspec.yaml'));
    if (!file.existsSync()) return false;

    try {
      final yaml = loadYaml(file.readAsStringSync());
      return yaml is YamlMap && yaml.containsKey('flutter');
    } catch (_) {
      return false;
    }
  }

  static String? apiKeyValidator(String? value) {
    if (isValidApiKey(value)) return null;
    return 'Invalid API key';
  }
}