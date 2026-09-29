import 'dart:io';

import 'package:flutter/material.dart';

class ImageField extends StatelessWidget {
  const ImageField({
    super.key,
    required this.path,
    required this.onPick,
    required this.onRemove,
  });

  final String? path;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Ảnh minh họa / hóa đơn'),
        const SizedBox(height: 8),
        if (path != null && File(path!).existsSync())
          Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(File(path!),
                  width: double.infinity, height: 180, fit: BoxFit.cover),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: IconButton.filled(
                  onPressed: onRemove, icon: const Icon(Icons.close)),
            ),
          ])
        else
          OutlinedButton.icon(
            onPressed: onPick,
            icon: const Icon(Icons.add_a_photo_outlined),
            label: const Text('Chụp hoặc chọn ảnh'),
          ),
      ]);
}
