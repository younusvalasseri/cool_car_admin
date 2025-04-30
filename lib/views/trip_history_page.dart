import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Widgets/app_colors.dart';
import '../Widgets/cool_car_app_bar.dart';
import '../providers/providers.dart';

class TripHistoryPage extends ConsumerWidget {
  const TripHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripHistoryProvider);

    return Scaffold(
      appBar: CoolCarAppBar(customTitle: 'Trip History', showIcons: false),
      body: tripsAsync.when(
        data: (snapshot) {
          final trips = snapshot.docs;

          if (trips.isEmpty) {
            return const Center(child: Text("No trip history available"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index].data();
              final ownerId = trip['ownerId'];
              final userId = trip['userId'];

              final ownerFuture = ref.read(userDetailsProvider(ownerId).future);
              final userFuture = ref.read(userDetailsProvider(userId).future);

              return FutureBuilder<List<dynamic>>(
                future: Future.wait([ownerFuture, userFuture]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Only show loader for the first card
                    return index == 0
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox(); // Empty space for other cards while first loads
                  }

                  if (snapshot.hasError || snapshot.data == null) {
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text("Error loading user details"),
                    );
                  }

                  final ownerData = snapshot.data![0] as Map<String, dynamic>?;
                  final userData = snapshot.data![1] as Map<String, dynamic>?;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: AppColors.primaryBlue,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "👤 Owner: ${ownerData?['name'] ?? 'Unknown'}",
                            style: const TextStyle(
                              color: AppColors.whiteText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "👤 User: ${userData?['name'] ?? 'Unknown'}",
                            style: const TextStyle(color: AppColors.whiteText),
                          ),
                          const Divider(color: AppColors.whiteText),
                          Text(
                            "📅 Pickup Date: ${formatDate(trip['pickupDate'])}",
                            style: const TextStyle(color: AppColors.whiteText),
                          ),
                          Text(
                            "🛑 Days: ${trip['days'] ?? 'N/A'}",
                            style: const TextStyle(color: AppColors.whiteText),
                          ),
                          Text(
                            "📍 Pickup: ${trip['pickupLocation'] ?? 'Unknown'}",
                            style: const TextStyle(color: AppColors.whiteText),
                          ),
                          Text(
                            "🎯 Destination: ${trip['destinationLocation'] ?? 'Unknown'}",
                            style: const TextStyle(color: AppColors.whiteText),
                          ),
                          const Divider(color: AppColors.whiteText),
                          Text(
                            "🚗 Vehicle: ${trip['car']['modelName'] ?? 'Unknown'}",
                            style: const TextStyle(color: AppColors.whiteText),
                          ),
                          Text(
                            "💰 Total Fare: ₹${(trip['totalFare'] as num).round()}",
                            style: const TextStyle(
                              color: AppColors.greenText,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("Error: $error")),
      ),
    );
  }
}
