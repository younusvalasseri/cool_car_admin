import 'package:cool_car_admin/providers/providers.dart';

import '../Widgets/app_colors.dart';
import '../Widgets/custom_text_field.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'register_page.dart';
import 'forgot_password.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final authState = ref.watch(authNotifierProvider);
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/building.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Positioned(
                        top: 80,
                        left: 30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello Cool Admin",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Welcome to Cool Management",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(flex: 5, child: Container()),
              ],
            ),
          ),

          // 🔹 Login Form Section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.625,
              decoration: const BoxDecoration(
                gradient: AppColors.loginBackgroundGradient,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // 🔹 Email Field
                    CustomTextField(
                      hint: "Email",
                      controller: emailController,
                      icon: Icons.email,
                    ),

                    // 🔹 Password Field
                    CustomTextField(
                      hint: "Password",
                      controller: passwordController,
                      icon: Icons.lock,
                      isPassword: true,
                    ),

                    // 🔹 Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    // 🔹 Sign In Button
                    ElevatedButton(
                      onPressed:
                          authState.isLoading
                              ? null
                              : () => authNotifier.signInWithEmail(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                                context,
                              ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        foregroundColor: AppColors.whiteText,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                        elevation: 5,
                      ),
                      child:
                          authState.isLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),

                    const SizedBox(height: 15),

                    // 🔹 Social Media Login
                    const Text(
                      "Login with social media",
                      style: TextStyle(color: AppColors.whiteText),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialButton(
                          'assets/google_icon.png',
                          () => authNotifier.signInWithGoogle(context),
                        ),
                        const SizedBox(width: 20),
                        _socialButton(
                          'assets/facebook_icon.png',
                          () => authNotifier.signInWithFacebook(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Sign Up Link
                    GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          ),
                      child: const Text(
                        "Don't have an account? Sign up",
                        style: TextStyle(
                          color: AppColors.whiteText,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(String asset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: AppColors.background,
        radius: 30,
        child: Image.asset(asset, height: 28),
      ),
    );
  }
}
