import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ownerDocumentsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('owner_documents').get();
  return querySnapshot.docs.map((doc) => doc.data()).toList();
});

class OwnerDocumentsPage extends ConsumerWidget {
  const OwnerDocumentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ownerDocuments = ref.watch(ownerDocumentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Owner Documents"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ownerDocuments.when(
          data: (documents) {
            if (documents.isEmpty) {
              return const Center(
                child: Text(
                  "No owner documents found.",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final doc = documents[index];

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.blue.shade700,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      doc['ownerName'] ?? "Unknown Owner",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDocumentRow("Bank Details", doc['Bank_Details']),
                        _buildDocumentRow(
                          "Police Clearance",
                          doc['Police_Clearance'],
                        ),
                        _buildDocumentRow(
                          "Driving License",
                          doc['Driving_License'],
                        ),
                        _buildDocumentRow(
                          "Aadhar Front",
                          doc['Aadhar_Card_Front'],
                        ),
                        _buildDocumentRow(
                          "Aadhar Back",
                          doc['Aadhar_Card_Back'],
                        ),
                        _buildDocumentRow("PAN Card", doc['Pan_Card']),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white70,
                    ),
                    onTap: () {
                      // Open document preview or action page
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text("Error: $error")),
        ),
      ),
    );
  }

  /// **🔹 Build Document Row**
  Widget _buildDocumentRow(String title, String? documentUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            documentUrl != null ? Icons.check_circle : Icons.error,
            color: documentUrl != null ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.white)),
          ),
          if (documentUrl != null)
            IconButton(
              icon: const Icon(Icons.remove_red_eye, color: Colors.white),
              onPressed: () {
                // TODO: Implement document preview functionality
              },
            ),
        ],
      ),
    );
  }
}
