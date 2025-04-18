import 'package:flutter/material.dart';

import '../Widgets/cool_car_app_bar.dart';
import '../views/admin_chat_list_page.dart';
import '../views/contact_support_page.dart';
import '../views/faq_page.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CoolCarAppBar(customTitle: 'Support', showIcons: false),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 50, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Need Help?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildSupportCard(
              icon: Icons.email,
              title: "Contact Support",
              description: "Send an email to our support team for assistance.",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ContactSupportPage()),
                );
              },
            ),
            _buildSupportCard(
              icon: Icons.chat,
              title: "Live Chat",
              description: "Chat with our support team in real-time.",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminChatListPage()),
                );
              },
            ),
            _buildSupportCard(
              icon: Icons.help_outline,
              title: "FAQs",
              description: "Find answers to frequently asked questions.",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FaqPage()),
                );
              },
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: const Text("Back to Settings"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **🔹 Support Card Widget**
  Widget _buildSupportCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.blue.shade700,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
        onTap: onTap,
      ),
    );
  }
}
