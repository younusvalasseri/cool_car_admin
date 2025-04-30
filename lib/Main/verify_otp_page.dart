import 'package:cool_car_admin/Widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Widgets/cool_car_app_bar.dart';
import '../providers/providers.dart';

class VerifyOtpPage extends ConsumerWidget {
  final String verificationId;
  final String phoneNumber;
  final String name;
  final String email;
  final String password;

  const VerifyOtpPage({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpState = ref.watch(otpNotifierProvider);
    final otpNotifier = ref.read(otpNotifierProvider.notifier);

    return Scaffold(
      appBar: CoolCarAppBar(customTitle: 'Verify OTP', showIcons: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter OTP sent to $phoneNumber",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // 🔹 OTP Input Field
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: otpNotifier.setOtp,
              decoration: const InputDecoration(
                hintText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Loading Indicator or Button
            otpState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                  onPressed:
                      () => otpNotifier.verifyOtp(context, verificationId),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: AppColors.black,
                  ),
                  child: const Text("Verify"),
                ),
          ],
        ),
      ),
    );
  }
}
