import 'package:cool_car_admin/Widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Widgets/cool_car_app_bar.dart';
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
      appBar: CoolCarAppBar(customTitle: 'Owner cars', showIcons: false),
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
                color: AppColors.primaryBlue,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: ListTile(
                  title: Text(
                    car['model'],
                    style: const TextStyle(color: AppColors.white),
                  ),

                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.white,
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
                              onDocumentsUpdated: (bool updated) {},
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
