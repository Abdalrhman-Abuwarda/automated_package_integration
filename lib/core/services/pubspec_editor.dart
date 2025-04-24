// lib/core/pubspec_editor.dart
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:yaml_edit/yaml_edit.dart';

class PubspecEditor {
  /// Returns `true` if it actually wrote something (i.e. the package was missing).
  Future<bool> addGoogleMaps(String projectDir, {String version = '^2.6.0'}) async {
    final pubspecPath = p.join(projectDir, 'pubspec.yaml');
    final file = File(pubspecPath);

    if (!file.existsSync()) {
      throw Exception('pubspec.yaml not found in $projectDir');
    }

    final original = file.readAsStringSync();
    final editor = YamlEditor(original);

    // Grab current dependencies (may be null)
    final depsPath = ['dependencies'];
    Map? deps;
    try {
      deps = editor.parseAt(depsPath).value as Map;
    } catch (_) {}

    // Already present? bail out
    if (deps != null && deps.containsKey('google_maps_flutter')) return false;

    // Insert or create the dependencies section
    if (deps == null) {
      editor.update(depsPath, {'google_maps_flutter': version});
    } else {
      editor.update([...depsPath, 'google_maps_flutter'], version);
    }

    file.writeAsStringSync(editor.toString());
    return true;
  }
}
