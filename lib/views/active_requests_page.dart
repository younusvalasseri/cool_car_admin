import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Widgets/app_colors.dart';
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

              final pickupLoc = (request['pickupLocation'] ?? 0.0);
              final destLoc = (request['destination'] ?? 0.0);

              final userFuture = ref.read(userDetailsProvider(userId).future);

              return FutureBuilder<List<dynamic>>(
                future: Future.wait([
                  getLocationName(pickupLoc),
                  getLocationName(destLoc),
                  userFuture,
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError || snapshot.data == null) {
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text("Error loading request details"),
                    );
                  }

                  final pickupAddress = snapshot.data![0] as String;
                  final destinationAddress = snapshot.data![1] as String;
                  final userData = snapshot.data![2] as Map<String, dynamic>?;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: AppColors.blueShade,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "👤 User: ${userData?['name'] ?? 'Unknown'}",
                            style: const TextStyle(
                              color: AppColors.whiteText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              final phone = userData?['phone'];
                              if (phone != null) {
                                launchDialer(phone);
                              }
                            },
                            child: Text(
                              "📞 Phone: ${userData?['phone'] ?? 'No phone'}",
                              style: const TextStyle(
                                color: AppColors.whiteText,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                          Text(
                            "📍 Pickup: $pickupAddress",
                            style: const TextStyle(color: AppColors.whiteText),
                          ),
                          Text(
                            "🎯 Destination: $destinationAddress",
                            style: const TextStyle(color: AppColors.whiteText),
                          ),
                          Text(
                            "📅 Pickup Date: ${formatDate(request['pickupDate'])}",
                            style: const TextStyle(color: AppColors.whiteText),
                          ),
                          Text(
                            "🛑 Days: ${request['days'] ?? 'N/A'}",
                            style: const TextStyle(color: AppColors.whiteText),
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
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
