import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Widgets/cool_car_app_bar.dart';
import '../Widgets/user_document_tile.dart';

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
      appBar: CoolCarAppBar(customTitle: 'Owner documents', showIcons: false),
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
                        DocumentRow(
                          title: "Bank Details",
                          documentUrl: doc['Bank_Details'],
                        ),
                        DocumentRow(
                          title: "Police Clearance",
                          documentUrl: doc['Police_Clearance'],
                        ),
                        DocumentRow(
                          title: "Driving License",
                          documentUrl: doc['Driving_License'],
                        ),
                        DocumentRow(
                          title: "Aadhar Back",
                          documentUrl: doc['Aadhar_Card_Back'],
                        ),
                        DocumentRow(
                          title: "Aadhar Front",
                          documentUrl: doc['Aadhar_Card_Front'],
                        ),
                        DocumentRow(
                          title: "PAN Card",
                          documentUrl: doc['Pan_Card'],
                        ),
                      ],
                    ),
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
}
