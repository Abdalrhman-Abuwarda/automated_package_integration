import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:yaml_edit/yaml_edit.dart';

/// Drops `maps_demo.dart`, guarantees flutter_riverpod is in pubspec.yaml,
/// and patches `main.dart` so the app starts on that demo screen.
/// Drops maps_demo.dart, ensures flutter_riverpod and wraps runApp with ProviderScope.
class DemoInjector {
  const DemoInjector();

  Future<bool> inject(String projectDir) async {
    bool changed = false;

    // 1️⃣  guarantee flutter_riverpod in pubspec.yaml
    final pubspecFile = File(p.join(projectDir, 'pubspec.yaml'));
    final editor = YamlEditor(pubspecFile.readAsStringSync());

    Map? deps;
    try {
      deps = editor.parseAt(['dependencies']).value as Map?;
    } catch (_) {/* no dependencies yet */}
    if (deps == null) {
      editor.update(['dependencies'], {'flutter_riverpod': '^2.6.1'});
      changed = true;
    } else if (!deps.containsKey('flutter_riverpod')) {
      editor.update(['dependencies', 'flutter_riverpod'], '^2.6.1');
      changed = true;
    }
    if (changed) pubspecFile.writeAsStringSync(editor.toString());

    // 2️⃣  add lib/maps_demo.dart (skip if already there)
    final demoPath = p.join(projectDir, 'lib', 'maps_demo.dart');
    if (!File(demoPath).existsSync()) {
      File(demoPath)
        ..createSync(recursive: true)
        ..writeAsStringSync(_demoCode);
      changed = true;
    }

    // 3️⃣  patch lib/main.dart
    final mainPath = p.join(projectDir, 'lib', 'main.dart');
    final mainFile = File(mainPath);
    if (mainFile.existsSync()) {
      var src = mainFile.readAsStringSync();

      // 3-a  ensure Riverpod import
      if (!src.contains("flutter_riverpod")) {
        src = "import 'package:flutter_riverpod/flutter_riverpod.dart';\n$src";
      }

      // 3-b  wrap runApp with ProviderScope
      final runAppRegex = RegExp(r'runApp\((.+?)\);\s*', dotAll: true);
      src = src.replaceFirstMapped(runAppRegex, (m) {
        final inner = m.group(1)!.trim();
        if (inner.startsWith('ProviderScope(')) return m.group(0)!; // already wrapped
        return 'runApp(const ProviderScope(child: $inner));\n';
      });

      // 3-c  import demo + set home: MapsDemo
      if (!src.contains("import 'maps_demo.dart'")) {
        src = "import 'maps_demo.dart';\n$src";
      }
      src = src.replaceFirst(
        RegExp(r'home\s*:\s*[^,]+,'),
        'home: const MapsDemo(),',
      );

      mainFile.writeAsStringSync(src);
      changed = true;
    }

    return changed;
  }

  // ------------------------------------------------------------------
  static const _demoCode = '''
// (same MapsDemo code as before)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final cameraProvider = StateProvider<CameraPosition>((_) =>
    const CameraPosition(target: LatLng(31.5, 34.45), zoom: 12));

class MapsDemo extends ConsumerWidget {
  const MapsDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final camera = ref.watch(cameraProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Google Maps Demo')),
      body: GoogleMap(
        initialCameraPosition: camera,
        myLocationButtonEnabled: false,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.zoom_in),
        onPressed: () {
          ref.read(cameraProvider.notifier).state = CameraPosition(
            target: camera.target,
            zoom: camera.zoom + 1,
          );
        },
      ),
    );
  }
}
''';
}

