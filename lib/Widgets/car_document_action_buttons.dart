import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

import '../providers/providers.dart';

class CarDocumentActionButtons extends StatelessWidget {
  final String? documentType;
  final String? fileUrl;
  final String? carId;
  final WidgetRef? ref;
  final Function(bool)? onDocumentsUpdated;
  final String? ownerId;

  const CarDocumentActionButtons({
    super.key,
    required this.documentType,
    required this.fileUrl,
    required this.carId,
    required this.ref,
    this.onDocumentsUpdated,
    required this.ownerId,
  });

  @override
  Widget build(BuildContext context) {
    if (carId != null && ref != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (fileUrl != null)
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.blue),
              onPressed: () => _previewFile(fileUrl),
            ),
          IconButton(
            icon: Icon(
              fileUrl != null ? Icons.edit : Icons.upload_file,
              color: Colors.blue,
            ),
            onPressed: () async {
              File? selectedFile = await _pickFile();
              if (selectedFile != null) {
                await ref
                    ?.read(carDocumentsProvider((ownerId!, carId!)).notifier)
                    .uploadCarDocument(documentType!, selectedFile);
                if (onDocumentsUpdated != null) onDocumentsUpdated!(true);
              }
            },
          ),
          if (fileUrl != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await ref!
                    .read(carDocumentsProvider((ownerId!, carId!)).notifier)
                    .deleteCarDocument(documentType!);
                if (onDocumentsUpdated != null) onDocumentsUpdated!(true);
              },
            ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Future<File?> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  void _previewFile(String? fileUrl) {
    if (fileUrl != null && fileUrl.isNotEmpty) {
      launchUrl(Uri.parse(fileUrl));
    }
  }
}
