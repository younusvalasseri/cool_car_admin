import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripHistoryPage extends ConsumerWidget {
  const TripHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip History"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('rental_history') // ✅ Fetch trip history
                .orderBy('pickupDate', descending: true) // Latest first
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final trips = snapshot.data!.docs;

          if (trips.isEmpty) {
            return const Center(child: Text("No trip history available"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index].data() as Map<String, dynamic>;
              final ownerId = trip['ownerId'];
              final userId = trip['userId'];

              return FutureBuilder<List<DocumentSnapshot>>(
                future: Future.wait([
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(ownerId)
                      .get(),
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .get(),
                ]),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final ownerData =
                      userSnapshot.data![0].data() as Map<String, dynamic>?;
                  final userData =
                      userSnapshot.data![1].data() as Map<String, dynamic>?;

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
                            "📅 Pickup Date: ${(trip['pickupDate'] as Timestamp).toDate()}",
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
                            "💰 Total Fare: ₹${trip['totalFare'] ?? '0'}",
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
              );
            },
          );
        },
      ),
    );
  }
}
