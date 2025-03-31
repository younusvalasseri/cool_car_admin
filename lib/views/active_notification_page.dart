import 'package:flutter/material.dart';

class ActiveNotificationPage extends StatelessWidget {
  const ActiveNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Active Notification")),
      body: const Center(child: Text("Active Notification List")),
    );
  }
}
