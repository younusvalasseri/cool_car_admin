import 'package:flutter/material.dart';
import 'password_reset_page.dart';

class ConfirmEmailOtpPage extends StatefulWidget {
  final String email;
  const ConfirmEmailOtpPage({super.key, required this.email});

  @override
  State<ConfirmEmailOtpPage> createState() => _ConfirmEmailOtpPageState();
}

class _ConfirmEmailOtpPageState extends State<ConfirmEmailOtpPage> {
  bool isVerifying = false;

  Future<void> _continueToReset() async {
    setState(() => isVerifying = true);

    try {
      if (!mounted) return;

      // 🔹 Navigate directly to Password Reset Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PasswordResetPage(email: widget.email),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isVerifying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Email Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'A password reset email has been sent to ${widget.email}. '
              'Please check your inbox and follow the instructions.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            isVerifying
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _continueToReset,
                    child: const Text('Continue to Reset Password'),
                  ),
          ],
        ),
      ),
    );
  }
}
