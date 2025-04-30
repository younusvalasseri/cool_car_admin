// confirm_otp_page.dart
import 'package:flutter/material.dart';
import 'password_reset_page.dart';

class ConfirmOtpPage extends StatelessWidget {
  final String phoneNumber;
  const ConfirmOtpPage({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();

    void verifyOtp() {
      // Implement Firebase OTP verification logic here
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PasswordResetPage(phoneNumber: phoneNumber),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Enter the OTP sent to $phoneNumber'),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: verifyOtp, child: const Text('Verify')),
          ],
        ),
      ),
    );
  }
}
