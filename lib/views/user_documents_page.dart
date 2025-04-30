import 'package:cool_car_admin/Widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Widgets/cool_car_app_bar.dart';
import '../Widgets/user_document_tile.dart';
import '../providers/providers.dart';

class UserDocumentsPage extends ConsumerWidget {
  const UserDocumentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDocuments = ref.watch(userDocumentsProvider);

    return Scaffold(
      appBar: CoolCarAppBar(customTitle: 'User Documents', showIcons: false),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: userDocuments.when(
          data: (documents) {
            if (documents.isEmpty) {
              return const Center(
                child: Text(
                  "No user documents found.",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final doc = documents[index];

                final userNameAsync = ref.watch(
                  userNameProvider(doc['userId']),
                );
                return userNameAsync.when(
                  data:
                      (userName) => Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: AppColors.primaryBlue,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            userName,
                            style: const TextStyle(color: AppColors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DocumentRow(
                                title: "Driving License",
                                documentUrl: doc['drivingLicense'],
                              ),
                              DocumentRow(
                                title: "Aadhar Card Front",
                                documentUrl: doc['aadharFront'],
                              ),
                              DocumentRow(
                                title: "Aadhar Card Back",
                                documentUrl: doc['aadharBack'],
                              ),
                              DocumentRow(
                                title: "Pan Card",
                                documentUrl: doc['panCard'],
                              ),
                            ],
                          ),
                        ),
                      ),
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error:
                      (error, _) => Text(
                        "Error: $error",
                        style: const TextStyle(color: AppColors.white),
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
