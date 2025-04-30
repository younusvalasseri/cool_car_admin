// lib\Widgets\custom_build_document_card.dart

import 'package:cool_car_admin/Widgets/app_colors.dart';
import 'package:flutter/material.dart';
import '../providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'car_document_action_buttons.dart';

class CustomBuildDocumentCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool? allUploaded;
  final String? documentType;
  final String? fileUrl;
  final OwnerDocumentsNotifier? ownerDocsNotifier;
  final String? carId;
  final WidgetRef? ref;
  final Function(bool)? onDocumentsUpdated;
  final String? ownerId;

  const CustomBuildDocumentCard({
    super.key,
    required this.title,
    required this.onTap,
    this.allUploaded,
    this.documentType,
    this.fileUrl,
    this.ownerDocsNotifier,
    this.carId,
    this.ref,
    this.onDocumentsUpdated,
    required this.ownerId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), // Top-left corner rounded
            bottomRight: Radius.circular(25), // Bottom-right corner rounded
          ),
        ),
        shadowColor: AppColors.black,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                fileUrl != null || allUploaded == true
                    ? Icons.check_circle
                    : Icons.upload_file,
                color:
                    fileUrl != null || allUploaded == true
                        ? AppColors.greenBack
                        : AppColors.redBack,
                size: 30,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  documentType ?? title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        fileUrl != null || allUploaded == true
                            ? AppColors.black
                            : AppColors.redBack,
                  ),
                ),
              ),
              CarDocumentActionButtons(
                ownerId: ownerId,
                documentType: documentType,
                fileUrl: fileUrl,
                carId: carId,
                ref: ref,
                onDocumentsUpdated: onDocumentsUpdated,
              ), // Actions (Upload, Delete, View)
            ],
          ),
        ),
      ),
    );
  }
}
