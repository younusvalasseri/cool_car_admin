import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Widgets/custom_build_document_card.dart';
import '../providers/providers.dart';

class CarDocumentsPage extends ConsumerWidget {
  final Function(bool) onDocumentsUpdated;
  final String carId;
  final String ownerId;
  final String carModel;

  const CarDocumentsPage({
    super.key,
    required this.onDocumentsUpdated,
    required this.carId,
    required this.ownerId,
    required this.carModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carDocsState = ref.watch(carDocumentsProvider((ownerId, carId)));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Car Documents"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF74BEED), Color(0x6674BEED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: carDocsState.when(
          data:
              (uploadedDocuments) => ListView(
                padding: const EdgeInsets.all(16),
                children:
                    uploadedDocuments.keys.map((documentType) {
                      String? fileUrl = uploadedDocuments[documentType];
                      return CustomBuildDocumentCard(
                        title: documentType,
                        documentType: documentType,
                        fileUrl: fileUrl,
                        carId: carId,
                        ref: ref,
                        ownerId: ownerId,
                        onTap: () {},
                      );
                    }).toList(),
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, stack) => Center(child: Text("Error: $e")),
        ),
      ),
    );
  }
}
