import 'package:cool_car_admin/Widgets/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Step 1: Create a provider for the WebViewController
final privacyPolicyWebViewControllerProvider = Provider<WebViewController>((
  ref,
) {
  final controller =
      WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(
          Uri.parse(
            'https://www.termsfeed.com/live/171590c7-8432-44cb-80a3-8c860cdb484f',
          ),
        );
  return controller;
});

class PrivacyPolicyPage extends ConsumerWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Step 3: Access the WebViewController from the provider
    final controller = ref.watch(privacyPolicyWebViewControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.white,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
