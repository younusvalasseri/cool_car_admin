//lib/Main/splash_screen.dart
import '../Main/auth_wrapper.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToAuthWrapper();
  }

  Future<void> _navigateToAuthWrapper() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      try {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AuthWrapper()),
          );
        });
      } catch (e, stack) {
        debugPrint('Navigation error: $e');
        debugPrintStack(stackTrace: stack);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Image.asset('assets/cool_car_logo.jpg', width: 200)),
    );
  }
}
