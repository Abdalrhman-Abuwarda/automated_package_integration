import 'dart:io';
import 'package:automated_package_integration/core/utils/app_strings.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;


class DirectoryPickerTile extends ConsumerWidget {
  const DirectoryPickerTile(
      {super.key, required this.folderOk, required this.projectDirProvider});

  final bool folderOk;
  final StateProvider<String?> projectDirProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dir = ref.watch(projectDirProvider);
    final hasPubspecFile = dir != null ? File(p.join(dir, 'pubspec.yaml')).existsSync() : true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          children: [
            Icon(folderOk ? Icons.folder_open : Icons.error,
                size: 30, color: folderOk ? null : Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(dir ?? AppStrings.selectDirectory,
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 12),
            TextButton(
              onPressed: () async {
                final path =
                    await getDirectoryPath(confirmButtonText: 'Select project');
                if (path != null) {
                  ref.read(projectDirProvider.notifier).state = path;
                }
              },
              child: const Text('Browse'),
            ),
          ],
        ),
        if (dir != null) ...[
          const SizedBox(height: 4),
          if (!hasPubspecFile)
            const Text(
              AppStrings.noPubspecFound,
              style: TextStyle(color: Colors.red, fontSize: 12),
            )
          else if (!folderOk)
            const Text(
              AppStrings.notFlutterProject,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
        ],
      ],
    );
  }
}
