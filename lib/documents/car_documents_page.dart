import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CarDocumentsPage extends ConsumerWidget {
  final String ownerId;
  final String carId;
  final String carModel;

  const CarDocumentsPage({
    super.key,
    required this.ownerId,
    required this.carId,
    required this.carModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carDocumentsProvider = FutureProvider<Map<String, dynamic>>((
      ref,
    ) async {
      final docSnapshot =
          await FirebaseFirestore.instance
              .collection('car_details')
              .doc(ownerId)
              .collection('cars')
              .doc(carId)
              .get();

      return docSnapshot.data() ?? {};
    });

    final carDocuments = ref.watch(carDocumentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("$carModel Documents"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: carDocuments.when(
        data: (documents) {
          if (documents.isEmpty) {
            return const Center(
              child: Text("No documents found for this car."),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildDocumentRow("Insurance", documents['Insurance']),
              _buildDocumentRow("Registration", documents['Registration']),
              _buildDocumentRow("Road Permit", documents['Road_Permit']),
              _buildDocumentRow(
                "Pollution Certificate",
                documents['Pollution_Certificate'],
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text("Error: $error")),
      ),
    );
  }

  /// **🔹 Build Document Row**
  Widget _buildDocumentRow(String title, String? documentUrl) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.blue.shade700,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing:
            documentUrl != null
                ? IconButton(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.white),
                  onPressed: () {
                    // TODO: Implement document preview functionality
                  },
                )
                : const Icon(Icons.error, color: Colors.red),
      ),
    );
  }
}
