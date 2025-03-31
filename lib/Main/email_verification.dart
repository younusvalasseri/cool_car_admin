import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'confirm_email_otp_page.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final TextEditingController emailController = TextEditingController();
  bool isSending = false;

  Future<void> _sendVerificationEmail() async {
    setState(() => isSending = true);

    String email = emailController.text.trim();

    try {
      if (email.isEmpty || !email.contains("@")) {
        throw FirebaseAuthException(
          code: "invalid-email",
          message: "Please enter a valid email address.",
        );
      }

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      } on FirebaseAuthException catch (e) {
        if (e.code == "user-not-found") {
          throw FirebaseAuthException(
            code: "email-not-registered",
            message: "This email is not registered. Please sign up first.",
          );
        } else {
          rethrow;
        }
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmEmailOtpPage(email: email),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } finally {
      if (mounted) {
        setState(() => isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Enter Email'),
            ),
            const SizedBox(height: 20),
            isSending
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _sendVerificationEmail,
                    child: const Text('Send Verification Email'),
                  ),
          ],
        ),
      ),
    );
  }
}
