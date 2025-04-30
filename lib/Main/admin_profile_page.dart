import 'package:cool_car_admin/Widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Widgets/cool_car_app_bar.dart';
import '../providers/providers.dart';
import 'password_reset_page.dart';

class AdminProfilePage extends ConsumerWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: Text("User not found")));
    }
    final userDetails = ref.watch(userDetailsProvider(user.uid));
    final updateUserName = ref.read(updateUserNameProvider(user.uid));
    final nameController = TextEditingController();
    final emailController = TextEditingController(text: user.email ?? '');

    return Scaffold(
      appBar: CoolCarAppBar(customTitle: 'Admin Profile', showIcons: true),
      body: userDetails.when(
        data: (data) {
          final photoUrl = data?['profilePhoto'];
          nameController.text = data?['name'] ?? user.displayName ?? 'Admin';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap:
                        () =>
                            PickAndUploadImage.pickAndUploadImage(ref, context),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryBlue,
                      backgroundImage:
                          photoUrl != null ? NetworkImage(photoUrl) : null,
                      child:
                          photoUrl == null
                              ? const Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.white,
                              )
                              : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () async {
                        final newName = nameController.text.trim();
                        if (newName.isEmpty) return;

                        try {
                          await updateUserName(newName);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Profile updated successfully!"),
                            ),
                          );
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Failed to update profile: $e"),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Email (read-only)
                TextField(
                  controller: emailController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                // Change Password
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PasswordResetPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text("Change Password"),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error loading user data: $e")),
      ),
    );
  }
}
