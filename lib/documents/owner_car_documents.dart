import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Widgets/cool_car_app_bar.dart';
import '../views/owner_cars_page.dart';

/// **🔹 Fetch List of Owners**
final ownersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('users').get();

  return querySnapshot.docs
      .map((doc) => {'id': doc.id, 'name': doc['name'] ?? 'Unknown Owner'})
      .toList();
});

/// **🔹 Fetch Cars for a Given Owner**
final ownerCarsProvider = FutureProvider.family<
  List<Map<String, dynamic>>,
  String
>((ref, ownerId) async {
  final querySnapshot =
      await FirebaseFirestore.instance
          .collection('car_details')
          .doc(ownerId)
          .collection('cars')
          .get();

  return querySnapshot.docs
      .map(
        (doc) => {'id': doc.id, 'model': doc['modelName'] ?? 'Unknown Model'},
      )
      .toList();
});

/// **🔹 OwnerCarDocumentsPage**
class OwnerCarDocumentsPage extends ConsumerWidget {
  const OwnerCarDocumentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owners = ref.watch(ownersProvider);

    return Scaffold(
      appBar: CoolCarAppBar(customTitle: 'Trip History', showIcons: false),
      body: owners.when(
        data: (ownersList) {
          if (ownersList.isEmpty) {
            return const Center(child: Text("No owners found."));
          }
          return ListView.builder(
            itemCount: ownersList.length,
            itemBuilder: (context, index) {
              final owner = ownersList[index];

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.blue.shade700,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: ListTile(
                  title: Text(
                    owner['name'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => OwnerCarsPage(
                              ownerId: owner['id'],
                              ownerName: owner['name'],
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text("Error: $error")),
      ),
    );
  }
}
