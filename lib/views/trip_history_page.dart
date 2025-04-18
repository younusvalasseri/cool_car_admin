import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

              final ownerAsync = ref.watch(userDetailsProvider(ownerId));
              final userAsync = ref.watch(userDetailsProvider(userId));

              return ownerAsync.when(
                data: (ownerData) {
                  return userAsync.when(
                    data: (userData) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.blue.shade700,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "👤 Owner: ${ownerData?['name'] ?? 'Unknown'}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "👤 User: ${userData?['name'] ?? 'Unknown'}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              const Divider(color: Colors.white),
                              Text(
                                "📅 Pickup Date: ${formatDate(trip['pickupDate'])}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                "🛑 Days: ${trip['days'] ?? 'N/A'}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                "📍 Pickup: ${trip['pickupLocation'] ?? 'Unknown'}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                "🎯 Destination: ${trip['destinationLocation'] ?? 'Unknown'}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              const Divider(color: Colors.white),
                              Text(
                                "🚗 Vehicle: ${trip['car']['modelName'] ?? 'Unknown'}",
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                "💰 Total Fare: ₹${(trip['totalFare'] as num).round()}",
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    loading:
                        () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text("Error loading user"),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text("Error loading owner"),
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
