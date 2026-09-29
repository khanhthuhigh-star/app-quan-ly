import 'dart:io';

import 'package:flutter/material.dart';

class Thumbnail extends StatelessWidget {
  const Thumbnail(
      {super.key, this.path, required this.icon, required this.color});
  final String? path;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 44,
          height: 44,
          child: path != null && File(path!).existsSync()
              ? Image.file(File(path!), fit: BoxFit.cover)
              : ColoredBox(
                  color: color.withValues(alpha: .13),
                  child: Icon(icon, color: color)),
        ),
      );
}
