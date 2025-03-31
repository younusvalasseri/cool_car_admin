// phone_verification.dart
import 'package:flutter/material.dart';
import 'confirm_otp_page.dart';

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({super.key});

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final TextEditingController phoneController = TextEditingController();

  void _sendOtp() {
    // Implement Firebase phone authentication logic here
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) =>
              ConfirmOtpPage(phoneNumber: phoneController.text.trim())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(labelText: 'Enter Phone Number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendOtp,
              child: const Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
