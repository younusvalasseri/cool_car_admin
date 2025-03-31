import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../documents/car_documents_page.dart';
import '../documents/owner_car_documents.dart';

class OwnerCarsPage extends ConsumerWidget {
  final String ownerId;
  final String ownerName;

  const OwnerCarsPage({
    super.key,
    required this.ownerId,
    required this.ownerName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cars = ref.watch(ownerCarsProvider(ownerId));

    return Scaffold(
      appBar: AppBar(
        title: Text("$ownerName's Cars"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: cars.when(
        data: (carList) {
          if (carList.isEmpty) {
            return const Center(child: Text("No cars registered."));
          }
          return ListView.builder(
            itemCount: carList.length,
            itemBuilder: (context, index) {
              final car = carList[index];

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.blue.shade700,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: ListTile(
                  title: Text(
                    car['model'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "License: ${car['licensePlate']}",
                    style: const TextStyle(color: Colors.white70),
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
                            (_) => CarDocumentsPage(
                              ownerId: ownerId,
                              carId: car['id'],
                              carModel: car['model'],
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
