import 'package:cool_car_admin/Main/password_reset_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../documents/owner_car_documents.dart';
import '../views/user_documents_page.dart';
import '../views/owner_documents_page.dart';
import 'PrivacyPolicyPage.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildSettingsCard(
              context,
              title: "Privacy Policy",
              icon: Icons.privacy_tip,
              page: const PrivacyPolicyPage(),
            ),
            _buildSettingsCard(
              context,
              title: "Reset Password",
              icon: Icons.lock_reset,
              page: const PasswordResetPage(),
            ),
            _buildSettingsCard(
              context,
              title: "User Documents",
              icon: Icons.file_copy,
              page: const UserDocumentsPage(),
            ),
            _buildSettingsCard(
              context,
              title: "Owner Documents",
              icon: Icons.assignment_ind,
              page: const OwnerDocumentsPage(),
            ),
            _buildSettingsCard(
              context,
              title: "Owner Car Documents",
              icon: Icons.directions_car,
              page: const OwnerCarDocumentsPage(),
            ),
          ],
        ),
      ),
    );
  }

  /// **🔹 Method to Build a Settings Card**
  Widget _buildSettingsCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget page,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.blue.shade700,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}
