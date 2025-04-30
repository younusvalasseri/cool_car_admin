// lib/Main/splash_screen.dart
import 'package:cool_car_admin/Widgets/app_colors.dart';

import '../Main/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  void _navigateToAuthWrapper(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    if (context.mounted) {
      try {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
        );
      } catch (e, stack) {
        debugPrint('Navigation error: $e');
        debugPrintStack(stackTrace: stack);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToAuthWrapper(context);
    });

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(child: Image.asset('assets/cool_car_logo.jpg', width: 200)),
    );
  }
}
