//lib/Main/auth_wrapper.dart
import '../views/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the snapshot has data (i.e. user is signed in), show HomePage.
        if (snapshot.hasData) {
          return const HomePage();
        }
        // Otherwise, show the LoginPage.
        return const LoginPage();
      },
    );
  }
}
