import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../Widgets/cool_car_app_bar.dart';

class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final messageController = TextEditingController();

    return Scaffold(
      appBar: CoolCarAppBar(customTitle: 'Contact Support', showIcons: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Send us a message",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "younusv@gmail.com",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Message",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  final message = messageController.text.trim();

                  final gmailWebUrl =
                      'https://mail.google.com/mail/?view=cm&to=younusv@gmail.com&su=CoolCar Support&body=From: $email\n\n$message';

                  final canLaunchEmail = await canLaunchUrlString(gmailWebUrl);

                  if (canLaunchEmail) {
                    await launchUrlString(gmailWebUrl);
                  } else {
                    if (!context.mounted) return;
                    showDialog(
                      context: context,
                      builder:
                          (ctx) => AlertDialog(
                            title: const Text("Couldn't launch Gmail"),
                            content: const Text(
                              "Please send your message to: younusv@gmail.com\n\n"
                              "We couldn’t open the email app directly on this device.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                    );
                  }
                },
                child: const Text("Send"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
