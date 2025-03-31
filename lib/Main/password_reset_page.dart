// password_reset_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordResetPage extends StatefulWidget {
  final String? email;
  final String? phoneNumber;

  const PasswordResetPage({super.key, this.email, this.phoneNumber});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isResetting = false;

  Future<void> _resetPassword() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => isResetting = true);
    try {
      // ✅ Get user using email & password authentication
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // Sign in the user again (Firebase requires re-authentication before updating passwords)
        AuthCredential credential = EmailAuthProvider.credential(
          email: widget.email!,
          password:
              "TemporaryPassword123!", // 🔹 Replace with the actual password if available
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        user = userCredential.user;
      }

      // ✅ Update the user's password
      await user?.updatePassword(passwordController.text.trim());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Password updated successfully! Please log in again.")),
      );

      Navigator.pop(context); // Navigate back to login
    } catch (e) {
      setState(() => isResetting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
            const SizedBox(height: 20),
            isResetting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _resetPassword,
                    child: const Text('Reset Password'),
                  ),
          ],
        ),
      ),
    );
  }
}
