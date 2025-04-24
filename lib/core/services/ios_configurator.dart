// lib/core/ios_configurator.dart
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:propertylistserialization/propertylistserialization.dart';

class IosConfigurator {
  const IosConfigurator();

  /// Adds or updates the <key>GMSApiKey</key> entry in Info.plist.
  ///
  /// Returns `true` if the file was changed.
  Future<bool> configure(String projectDir, String apiKey) async {
    final plistPath = p.join(projectDir, 'ios', 'Runner', 'Info.plist');
    final file = File(plistPath);
    if (!file.existsSync()) {
      throw Exception('Info.plist not found – did you pick the right folder?');
    }

    // 1. deserialize
    final root = PropertyListSerialization.propertyListWithString(
      file.readAsStringSync(),
    ) as Map<String, Object?>;

    // 2. mutate
    final oldValue = root['GMSApiKey'];
    if (oldValue == apiKey) return false;          // nothing to do
    root['GMSApiKey'] = apiKey;

    // 3. serialize & write
    final newXml = PropertyListSerialization.stringWithPropertyList(root);
    file.writeAsStringSync(newXml);
    return true;
  }
}
