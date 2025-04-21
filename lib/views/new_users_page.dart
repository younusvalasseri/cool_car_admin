import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_car_admin/Widgets/cool_car_app_bar.dart';
import 'package:cool_car_admin/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewUsersPage extends ConsumerWidget {
  const NewUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersSnapshot = ref.watch(todayNewUsersProvider);

    return Scaffold(
      appBar: CoolCarAppBar(customTitle: 'Todays New Users', showIcons: false),
      backgroundColor: Colors.grey[900],
      body: usersSnapshot.when(
        data: (snapshot) {
          final users = snapshot.docs;

          if (users.isEmpty) {
            return const Center(
              child: Text(
                "No users registered today.",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;
              final name = user['name'] ?? 'Unnamed';
              final email = user['email'] ?? 'No email';
              final createdAt = (user['createdAt'] as Timestamp).toDate();

              return ListTile(
                title: Text(name, style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                  email,
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: Text(
                  "${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(color: Colors.white54),
                ),
              );
            },
          );
        },
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
        error:
            (e, _) => Center(
              child: Text(
                "Error: $e",
                style: const TextStyle(color: Colors.red),
              ),
            ),
      ),
    );
  }
}
