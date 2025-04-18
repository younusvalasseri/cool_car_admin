import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Widgets/cool_car_app_bar.dart';
import '../providers/providers.dart';

class ActiveRequestsPage extends ConsumerWidget {
  const ActiveRequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestStream = ref.watch(activeRequestsStreamProvider);

    return Scaffold(
      appBar: CoolCarAppBar(customTitle: 'Active Requests', showIcons: false),
      body: requestStream.when(
        data: (snapshot) {
          final requests = snapshot.docs;

          if (requests.isEmpty) {
            return const Center(child: Text("No active requests"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index].data() as Map<String, dynamic>;
              final userId = request['userId'];

              final userDetailsAsync = ref.watch(userDetailsProvider(userId));

              return userDetailsAsync.when(
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
                            "👤 User: ${userData?['name'] ?? 'Unknown'}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "📞 Phone: ${userData?['phone'] ?? 'No phone'}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            "📍 Pickup: ${request['pickupLocation'] ?? 'Unknown'}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            "🎯 Destination: ${request['destinationLocation'] ?? 'Unknown'}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            "📅 Pickup Date: ${(request['pickupDate'] as Timestamp).toDate()}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            "🛑 Days: ${request['days'] ?? 'N/A'}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading:
                    () => const Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                error:
                    (e, _) => Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text("Error loading user: $e"),
                    ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
