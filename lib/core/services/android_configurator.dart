// lib/core/android_configurator.dart
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';

class AndroidConfigurator {
  const AndroidConfigurator();

  /// Injects the meta‑data tag **and** the permission (if missing).
  ///
  /// Returns `true` if the file was modified.
  Future<bool> configure(String projectDir, String apiKey) async {
    final manifestPath =
    p.join(projectDir, 'android', 'app', 'src', 'main', 'AndroidManifest.xml');
    final file = File(manifestPath);
    if (!file.existsSync()) {
      throw Exception('AndroidManifest.xml not found ‑ did you pick the right folder?');
    }

    final doc = XmlDocument.parse(file.readAsStringSync());
    final application = doc.findAllElements('application').first;

    bool changed = false;

    // ---- API‑key meta‑data ----
    final alreadyHasKey = application.findElements('meta-data').any((e) =>
    e.getAttribute('android:name') == 'com.google.android.geo.API_KEY');
    if (!alreadyHasKey) {
      application.children.add(XmlElement(
        XmlName('meta-data'),
        [
          XmlAttribute(XmlName('android:name'),
              'com.google.android.geo.API_KEY'),
          XmlAttribute(XmlName('android:value'), apiKey),
        ],
      ));
      changed = true;
    }

    // ---- Location permission  ----
    final manifest = doc.getElement('manifest')!;
    final hasPermission = manifest.findElements('uses-permission').any((e) =>
    e.getAttribute('android:name') ==
        'android.permission.ACCESS_FINE_LOCATION');
    if (!hasPermission) {
      manifest.children.add(XmlElement(
        XmlName('uses-permission'),
        [
          XmlAttribute(XmlName('android:name'),
              'android.permission.ACCESS_FINE_LOCATION'),
        ],
      ));
      changed = true;
    }

    if (changed) file.writeAsStringSync(doc.toXmlString(pretty: true));
    return changed;
  }
}
