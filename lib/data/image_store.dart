import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageStore {
  static Future<String?> pickAndCopy(ImageSource source) async {
    final picked = await ImagePicker()
        .pickImage(source: source, imageQuality: 78, maxWidth: 1600);
    if (picked == null) return null;

    final directory = await getApplicationDocumentsDirectory();
    final imageDirectory =
        Directory(path.join(directory.path, 'transaction_images'));
    if (!await imageDirectory.exists()) {
      await imageDirectory.create(recursive: true);
    }
    final fileName =
        '${DateTime.now().microsecondsSinceEpoch}${path.extension(picked.path)}';
    return (await File(picked.path)
            .copy(path.join(imageDirectory.path, fileName)))
        .path;
  }

  static Future<void> delete(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) await file.delete();
  }
}
