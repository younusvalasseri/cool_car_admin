import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Privacy Policy",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildPolicySection(
              "1. Introduction",
              "Welcome to CoolCar Admin! This Privacy Policy outlines how we collect, use, and protect your personal information when using our app.",
            ),
            _buildPolicySection(
              "2. Information We Collect",
              "We collect the following types of information:\n\n"
                  "- User-provided data: Name, phone number, and email address.\n"
                  "- Uploaded documents: Identification proofs, licenses, and bank details.\n"
                  "- Usage data: Activity logs and interactions with the app.",
            ),
            _buildPolicySection(
              "3. How We Use Your Information",
              "We use your data for:\n\n"
                  "- Account verification and management.\n"
                  "- Processing rental requests and payments.\n"
                  "- Improving app functionality and security.",
            ),
            _buildPolicySection(
              "4. Data Protection",
              "We implement strong security measures to protect your personal data from unauthorized access, disclosure, or modification.",
            ),
            _buildPolicySection(
              "5. Sharing of Information",
              "We do not sell or rent your personal data. However, we may share your data with law enforcement authorities if required by law.",
            ),
            _buildPolicySection(
              "6. Your Rights",
              "You have the right to:\n\n"
                  "- Access, update, or delete your data.\n"
                  "- Request a copy of your personal data.\n"
                  "- Withdraw consent for data processing.",
            ),
            _buildPolicySection(
              "7. Contact Us",
              "If you have any questions about this Privacy Policy, please contact us at support@coolcar.com.",
            ),
            const SizedBox(height: 20),
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

  /// **🔹 Build Policy Section**
  Widget _buildPolicySection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 5),
        Text(content, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 15),
      ],
    );
  }
}
