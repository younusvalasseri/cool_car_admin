import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Support"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                // Handle email support logic here
              },
            ),
            _buildSupportCard(
              icon: Icons.report_problem,
              title: "Report an Issue",
              description: "Let us know if you are facing any problems.",
              onTap: () {
                // Handle issue reporting logic
              },
            ),
            _buildSupportCard(
              icon: Icons.chat,
              title: "Live Chat",
              description: "Chat with our support team in real-time.",
              onTap: () {
                // Navigate to chat support page
              },
            ),
            _buildSupportCard(
              icon: Icons.help_outline,
              title: "FAQs",
              description: "Find answers to frequently asked questions.",
              onTap: () {
                // Navigate to FAQs page
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
