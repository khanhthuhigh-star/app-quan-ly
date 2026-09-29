import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource?> chooseImageSource(BuildContext context) =>
    showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(children: [
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text('Chụp ảnh'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Chọn từ thư viện'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ]),
      ),
    );

Future<bool> askConfirmation(BuildContext context, String message) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(content: Text(message), actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy')),
        FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa')),
      ]),
    ) ??
    false;
