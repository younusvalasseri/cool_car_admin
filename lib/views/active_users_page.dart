import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Widgets/app_colors.dart';
import '../Widgets/cool_car_app_bar.dart';

final usersProvider = StreamProvider((ref) {
  return FirebaseFirestore.instance.collection('users').snapshots();
});

class ActiveUsersPage extends ConsumerWidget {
  const ActiveUsersPage({super.key});

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint("Password reset error: $e");
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
    } catch (e) {
      debugPrint("User deletion error: $e");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersSnapshot = ref.watch(usersProvider);

    return Scaffold(
      appBar: CoolCarAppBar(customTitle: 'Active Users', showIcons: false),
      body: usersSnapshot.when(
        data: (snapshot) {
          if (snapshot.docs.isEmpty) {
            return const Center(child: Text("No active users found"));
          }

          return ListView.builder(
            itemCount: snapshot.docs.length,
            itemBuilder: (context, index) {
              final user = snapshot.docs[index].data();
              final userId = snapshot.docs[index].id;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.greyBack,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(user['name'] ?? "Unknown"),
                  subtitle: Text(user['email'] ?? "No email"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.lock_reset, color: AppColors.blueIcon),
                        onPressed: () {
                          resetPassword(user['email']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Password reset link sent!"),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: AppColors.redIcon,
                        ),
                        onPressed: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text("Delete User"),
                                  content: const Text(
                                    "Are you sure you want to delete this user?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(
                                          color: AppColors.redText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true) {
                            deleteUser(userId);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
