import 'dart:io';
import 'package:flutter/material.dart';

class ImageViewerWidget extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;

  const ImageViewerWidget({super.key, this.imageFile, this.imageUrl});

  // Image or icon error builder

  @override
  Widget build(BuildContext context) {
    return imageFile != null
        ? Image.file(
            imageFile!,
            fit: BoxFit.cover,
            width: 100,
            height: 100,
          )
        : imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              )
            : const Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.grey,
              );
  }
}
